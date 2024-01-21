import 'dart:async';
import 'dart:typed_data' as td;

import 'package:backend/src/common/database/database.dart' as db;
import 'package:backend/src/common/server/responses.dart';
import 'package:shared/shared.dart' as shared;
import 'package:shelf/shelf.dart' as shelf;

/// Returns the last articles from the database.
///
/// E.g. `http://127.0.0.1:8080/articles?format=json`
FutureOr<shelf.Response> $getArticles(shelf.Request request) async {
  final database = request.context['DATABASE'] as db.Database;

  int? parseQueryInt(String? name) => switch (request.requestedUri.queryParameters[name]?.trim()) {
        String value when value.isNotEmpty => int.tryParse(value),
        _ => null,
      };
  final from = parseQueryInt('from');
  final to = parseQueryInt('to');
  final limit = parseQueryInt('limit');
  final offset = parseQueryInt('offset');
  final articles = await _getArticlesFromDatabase(database, from: from, to: to, limit: limit, offset: offset);
  switch (request.requestedUri.queryParameters['format']?.trim().toLowerCase()) {
    case 'json':
      return Responses.ok(
        <String, Object?>{
          'articles': <Object?>[for (final article in articles) article.toProto3Json()],
          'count': articles.length,
        },
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
      );
    case 'pretty' || 'csv' || 'tsv' || 'human' || 'text':
      final buffer = StringBuffer();
      const separator = ',';
      for (final article in articles) {
        buffer
          ..write(article.id)
          ..write(separator)
          ..write(DateTime.fromMillisecondsSinceEpoch(article.createdAt * 1000))
          ..write(separator)
          ..write(DateTime.fromMillisecondsSinceEpoch(article.updatedAt * 1000))
          ..write(separator)
          ..write(article.title)
          ..writeln();
      }
      return Responses.ok(
        buffer.toString(),
        headers: <String, String>{
          'Content-Type': 'text/plain; charset=utf-8',
        },
      );
    case 'proto' || 'protobuf':
    default:
      return Responses.ok(
        shared.Articles(
          articles: articles,
          count: articles.length,
        ).writeToBuffer(),
      );
  }
}

/// Get articles from the database.
Future<List<shared.Article>> _getArticlesFromDatabase(
  db.Database database, {
  int? from,
  int? to,
  int? limit,
  int? offset,
}) async {
  final select = database.select(database.articleTbl);
  if (from != null) select.where((tbl) => tbl.createdAt.isBiggerOrEqualValue(from));
  if (to != null) select.where((tbl) => tbl.createdAt.isSmallerOrEqualValue(to));
  select
    ..limit(limit ?? 1000, offset: offset ?? 0)
    ..orderBy([(tbl) => db.OrderingTerm.asc(tbl.createdAt)]);
  return await select.get().then((rows) => rows
      .map<td.Uint8List>((e) => e.data)
      .map<shared.Article>(shared.Article.fromBuffer)
      .map((e) => e..content = '') // remove content
      .toList(growable: false));
}
