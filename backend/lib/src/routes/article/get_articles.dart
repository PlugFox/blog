import 'dart:async';

import 'package:backend/src/common/medium/article_converter.dart';
import 'package:backend/src/common/medium/article_dao.dart';
import 'package:backend/src/common/server/responses.dart';
import 'package:shared/shared.dart' as shared;
import 'package:shelf/shelf.dart' as shelf;

/// Returns the last articles from the database.
///
/// E.g. `http://127.0.0.1:8080/articles?format=json`
FutureOr<shelf.Response> $getArticles(shelf.Request request) async {
  final dao = request.context['ARTICLE_DAO'] as ArticleDAO;

  int? parseQueryInt(String? name) => switch (request.requestedUri.queryParameters[name]?.trim()) {
        String value when value.isNotEmpty => int.tryParse(value),
        _ => null,
      };
  final from = parseQueryInt('from');
  final to = parseQueryInt('to');
  final limit = parseQueryInt('limit');
  final offset = parseQueryInt('offset');
  final articles = await dao.getArticlesFromDatabase(from: from, to: to, limit: limit, offset: offset);
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
