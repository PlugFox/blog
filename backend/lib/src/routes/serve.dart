import 'dart:async';

import 'package:backend/src/common/config/config.dart';
import 'package:backend/src/common/database/database.dart';
import 'package:backend/src/common/medium/article_dao.dart';
import 'package:backend/src/common/server/authorization.dart';
import 'package:backend/src/common/server/cors.dart';
import 'package:backend/src/common/server/handle_errors.dart';
import 'package:backend/src/common/server/injector.dart';
import 'package:backend/src/common/server/log.dart';
import 'package:backend/src/common/server/responses.dart';
import 'package:backend/src/routes/admin/check.dart';
import 'package:backend/src/routes/admin/config.dart';
import 'package:backend/src/routes/admin/health.dart';
import 'package:backend/src/routes/admin/logs.dart';
import 'package:backend/src/routes/article/article.dart';
import 'package:backend/src/routes/article/articles.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

/// Serves the application.
/// Provides the middleware and the routes.
Future<void> serve({
  required Config config,
  required Database database,
}) async {
  final articleDao = ArticleDAO(database: database);
  final pipeline = const shelf.Pipeline()
      // TODO(plugfox): add middleware for meta headers
      .addMiddleware(cors())
      .addMiddleware(handleErrors(showStackTrace: config.environment.isDevelopment))
      .addMiddleware(logPipeline())
      .addMiddleware(authorization(config.token))
      .addMiddleware(injector(<String, Object>{
        'DATABASE': database,
        'CONFIG': config,
        'ARTICLE_DAO': articleDao,
      }))
      .addHandler(_$router);
  await shelf_io.serve(
    pipeline,
    config.address,
    config.port,
    poweredByHeader: 'Dart',
    shared: config.workers > 1,
    backlog: config.workers * 4, // 4x workers for backlog, it's pretty cheap and low value.
  );
}

/// The router for the application.
shelf.Handler get _$router => (Router(notFoundHandler: _$notFound)
      ..get('/admin/health', $healthCheck)
      ..get('/admin/logs', $logs)
      ..get('/admin/config', $config)
      ..get('/admin/articles', $checkArticles)
      /* ..patch('/admin/articles', $upsertArticlesByURLs) */
      /* ..put('/admin/articles', $upsertArticles) */
      /* ..post('/admin/articles', $upsertArticles) */
      /* ..delete('/admin/articles/<id>', $deleteArticle) */
      /* ..get('/admin/stat', $stat) */
      /* ..get('/admin/echo', $echo) */
      /* ..get('/admin/schema', $schema) */
      /* ..get('/admin/<subject>', $...) */
      ..get('/articles', $getArticles)
      ..get('/articles/<id>', $getArticle)
      ..all('/<ignored|.*>', _$notFound)) // Redirect to site
    .call;

FutureOr<shelf.Response> _$notFound(shelf.Request request) => Responses.error(
      NotFoundException(data: <String, Object?>{
        'path': request.url.path,
        'query': request.url.queryParameters,
        'method': request.method,
        'headers': request.headers,
      }),
    );
