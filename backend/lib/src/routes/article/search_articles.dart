import 'dart:async';

import 'package:backend/src/common/medium/article_converter.dart';
import 'package:backend/src/common/server/injector.dart';
import 'package:backend/src/common/server/responses.dart';
import 'package:shared/shared.dart' as shared;
import 'package:shelf/shelf.dart' as shelf;

/// Search articles in the database.
///
/// E.g. `http://127.0.0.1:8080/articles/search?q=text&limit=100&format=json`
FutureOr<shelf.Response> $searchArticles(shelf.Request request) async {
  final Dependencies(articleDAO: dao) = Dependencies.from(request);

  int? parseQueryInt(String? name) => switch (request.requestedUri.queryParameters[name]?.trim()) {
        String value when value.isNotEmpty => int.tryParse(value),
        _ => null,
      };

  String? getQueryParameters(Iterable<String> names) => names
      .map<String?>((name) => request.requestedUri.queryParameters[name])
      .firstWhere((value) => value != null && value.isNotEmpty, orElse: () => null);

  final search = getQueryParameters(['q', 'query', 's', 'search']);
  if (search == null || search.isEmpty)
    return Responses.error(const BadRequestException(detail: 'Missing search query'));
  final limit = parseQueryInt('limit');
  final articles = await dao.searchInDatabase(search, limit: limit ?? 100);
  for (final article in articles) article.content = '';
  switch (request.requestedUri.queryParameters['format']?.trim().toLowerCase()) {
    case 'json':
      const converter = Article2JSON();
      return Responses.ok(
        <String, Object?>{
          'articles': <Object?>[for (final article in articles) converter.convert(article)],
          'count': articles.length,
        },
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
      );
    case 'csv' || 'tsv':
      final buffer = StringBuffer('')..writeln('id,created_at,updated_at,title');
      for (final article in articles) Article2CSV.addArticleToBuffer(article, buffer);
      return Responses.ok(
        buffer.toString(),
        headers: <String, String>{
          'Content-Type': 'text/plain; charset=utf-8',
        },
      );
    case 'pretty' || 'human' || 'text':
      final buffer = StringBuffer('');
      for (final article in articles) buffer.writeln('- ${article.title}');
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
        headers: <String, String>{
          'Content-Type': 'application/octet-stream',
        },
      );
  }
}
