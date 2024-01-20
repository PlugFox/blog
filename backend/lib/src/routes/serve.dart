import 'package:backend/src/common/config/config.dart';
import 'package:backend/src/common/database/database.dart';
import 'package:backend/src/common/server/authorization.dart';
import 'package:backend/src/common/server/cors.dart';
import 'package:backend/src/common/server/handle_errors.dart';
import 'package:backend/src/common/server/injector.dart';
import 'package:backend/src/common/server/log_pipeline.dart';
import 'package:backend/src/routes/meta/config.dart';
import 'package:backend/src/routes/meta/health.dart';
import 'package:backend/src/routes/meta/logs.dart';
import 'package:backend/src/routes/meta/not_found.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

Future<void> serve({
  required Config config,
  required Database database,
}) async {
  final pipeline = const shelf.Pipeline()
      .addMiddleware(handleErrors(showStackTrace: config.environment.isDevelopment))
      .addMiddleware(logPipeline())
      .addMiddleware(cors())
      .addMiddleware(authorization())
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
    backlog: config.workers * 2, // 2x workers for backlog, it's pretty cheap and low value.
  );
}

shelf.Handler get _$router => (Router(notFoundHandler: $notFound)
      /* ..get('/stat', $stat) */
      //..get('/authenticate/<subject>', $authenticate)
      ..get('/health', $healthCheck)
      ..get('/logs', $logs)
      ..get('/config', $config)
      ..all('/<ignored|.*>', $notFound))
    .call;
