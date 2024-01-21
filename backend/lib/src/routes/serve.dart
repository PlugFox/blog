import 'package:backend/src/common/config/config.dart';
import 'package:backend/src/common/database/database.dart';
import 'package:backend/src/common/server/authorization.dart';
import 'package:backend/src/common/server/cors.dart';
import 'package:backend/src/common/server/handle_errors.dart';
import 'package:backend/src/common/server/injector.dart';
import 'package:backend/src/common/server/log.dart';
import 'package:backend/src/routes/admin/config.dart';
import 'package:backend/src/routes/admin/health.dart';
import 'package:backend/src/routes/admin/logs.dart';
import 'package:backend/src/routes/admin/not_found.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

/// Serves the application.
/// Provides the middleware and the routes.
Future<void> serve({
  required Config config,
  required Database database,
}) async {
  final pipeline = const shelf.Pipeline()
      // TODO(plugfox): add middleware for meta headers
      .addMiddleware(cors())
      .addMiddleware(handleErrors(showStackTrace: config.environment.isDevelopment))
      .addMiddleware(logPipeline())
      .addMiddleware(authorization(config.token))
      .addMiddleware(injector(<String, Object>{
        'DATABASE': database,
        'CONFIG': config,
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
shelf.Handler get _$router => (Router(notFoundHandler: $notFound)
      ..get('/admin/health', $healthCheck)
      ..get('/admin/logs', $logs)
      ..get('/admin/config', $config)
      /* ..get('/admin/stat', $stat) */
      /* ..get('/admin/echo', $echo) */
      /* ..get('/admin/<subject>', $...) */
      ..all('/<ignored|.*>', $notFound))
    .call;
