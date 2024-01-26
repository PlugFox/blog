import 'dart:async';

import 'package:backend/src/common/config/app_metadata.dart';
import 'package:backend/src/common/server/injector.dart';
import 'package:backend/src/common/server/responses.dart';
import 'package:shelf/shelf.dart' as shelf;

FutureOr<shelf.Response> $config(shelf.Request request) {
  final metadata = AppMetadata();
  final Dependencies(:config) = Dependencies.from(request);
  return Responses.ok(
    <String, Object?>{
      'environment': config.environment.name,
      'verbose': config.verbose,
      'interval': '${config.interval}s',
      'address': config.address.host,
      'port': config.port,
      'workers': config.workers,
      'debug': metadata.debug,
      'name': metadata.name,
      'version': metadata.version.representation.toString(),
      'timestamp': metadata.built.toIso8601String(),
      'os': metadata.os,
      'cpus': metadata.cpus,
      'locale': metadata.locale,
      'launched': metadata.launched.toIso8601String(),
      'now': DateTime.now().toIso8601String(),
    },
  );
}
