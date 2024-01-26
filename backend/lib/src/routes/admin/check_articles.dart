import 'dart:async';

import 'package:backend/src/common/medium/article_dao.dart';
import 'package:backend/src/common/medium/medium.dart';
import 'package:backend/src/common/server/injector.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart' as shelf;

/// Check articles.
///
/// E.g. `http://127.0.0.1:8080/admin/articles/check
FutureOr<shelf.Response> $checkArticles(shelf.Request request) async {
  final Dependencies(:config, :database) = Dependencies.from(request);
  final client = http.Client();
  final medium = Medium(client: client);
  final dao = ArticleDAO(database: database);
  final articles = await medium.fetchArticlesRSS(config.username);
  await dao.upsertArticlesIntoDatabase(articles);
  client.close();
  return shelf.Response.ok('OK');
}
