import 'dart:async';

import 'package:backend/src/common/config/config.dart';
import 'package:backend/src/common/database/database.dart' as db;
import 'package:backend/src/common/medium/medium.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart' as shelf;

/// Check articles.
///
/// E.g. `http://127.0.0.1:8080/admin/check
FutureOr<shelf.Response> $checkArticles(shelf.Request request) async {
  final config = request.context['CONFIG'] as Config;
  final database = request.context['DATABASE'] as db.Database;
  final client = http.Client();
  final medium = Medium(client: client, database: database);
  final articles = await medium.fetchArticlesRSS(config.username);
  await medium.upsertArticlesIntoDatabase(articles);
  client.close();
  return shelf.Response.ok('OK');
}
