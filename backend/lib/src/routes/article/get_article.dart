import 'dart:async';

import 'package:backend/src/common/medium/article_converter.dart';
import 'package:backend/src/common/medium/article_dao.dart';
import 'package:backend/src/common/server/responses.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';

/// Returns the article with the given id.
///
/// E.g. `http://127.0.0.1:8080/article/:id?format=json`
FutureOr<shelf.Response> $getArticle(shelf.Request request) async {
  final id = request.params['id'];

  FutureOr<shelf.Response> notFound() => Responses.error(NotFoundException(
        detail: 'Article not found',
        data: <String, Object?>{
          'id': id,
        },
      ));
  if (id == null || id.isEmpty) return notFound();

  final dao = request.context['ARTICLE_DAO'] as ArticleDAO;
  final article = await dao.getArticleFromDatabase(id);
  if (article == null) return notFound();
  switch (request.requestedUri.queryParameters['format']?.trim().toLowerCase()) {
    case 'json':
      return Responses.ok(
        const Article2JSON().convert(article),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
      );
    case 'csv' || 'tsv':
      final buffer = StringBuffer()..writeln('id,created_at,updated_at,title');
      Article2CSV.addArticleToBuffer(article, buffer);
      return Responses.ok(
        buffer.toString(),
        headers: <String, String>{
          'Content-Type': 'text/plain; charset=utf-8',
        },
      );
    case 'pretty' || 'html' || 'web' || 'browser' || 'human' || 'text':
      return Responses.ok(
        '<html>\n'
        ' <head>\n'
        '  <title>${article.title}</title>\n'
        ' </head>\n'
        ' <body>\n'
        '  <h1>${article.title}</h1>\n'
        '  <div>${article.content}</div>\n'
        ' </body>\n'
        '</html>',
        headers: <String, String>{
          'Content-Type': 'text/html; charset=utf-8',
        },
      );
    case 'proto' || 'protobuf':
    default:
      return Responses.ok(
        const Article2Bytes().convert(article),
        headers: <String, String>{
          'Content-Type': 'application/octet-stream',
        },
      );
  }
}
