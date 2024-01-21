import 'dart:async';
import 'dart:typed_data' as td;

import 'package:backend/src/common/database/database.dart' as db;
import 'package:backend/src/common/server/responses.dart';
import 'package:shared/shared.dart' as shared;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';

/// Returns the article with the given id.
///
/// E.g. `http://127.0.0.1:8080/article/:id?format=json`
FutureOr<shelf.Response> $getArticle(shelf.Request request) async {
  final database = request.context['DATABASE'] as db.Database;

  final id = request.params['id'];

  FutureOr<shelf.Response> notFound() => Responses.error(NotFoundException(
        detail: 'Article not found',
        data: <String, Object?>{
          'id': id,
        },
      ));
  if (id == null || id.isEmpty) return notFound();
  final article = await _getArticleFromDatabase(database, id);
  if (article == null) return notFound();
  switch (request.requestedUri.queryParameters['format']?.trim().toLowerCase()) {
    case 'json':
      return Responses.ok(
        article.toProto3Json(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
      );
    case 'pretty' || 'human' || 'html' || 'text':
      return Responses.ok(
        '<html>'
        '<head>'
        '<title>${article.title}</title>'
        '</head>'
        '<body>'
        '<h1>${article.title}</h1>'
        '<div>${article.content}</div>'
        '</body>'
        '</html>',
        headers: <String, String>{
          'Content-Type': 'text/html; charset=utf-8',
        },
      );
    case 'proto' || 'protobuf':
    default:
      return Responses.ok(article.writeToBuffer());
  }
}

/// Get articles from the database.
Future<shared.Article?> _getArticleFromDatabase(db.Database database, String id) async {
  final select = database.select(database.articleTbl)
    ..where((tbl) => tbl.id.equals(id))
    ..limit(1);
  final data = await select.getSingleOrNull().then<td.Uint8List?>((row) => row?.data);
  if (data == null) return null;
  return shared.Article.fromBuffer(data);
}
