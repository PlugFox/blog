import 'dart:io' as io;

import 'package:backend/src/common/config/config.dart';
import 'package:backend/src/common/config/initialization.dart';
import 'package:backend/src/common/database/database.dart';
import 'package:l/l.dart';

/// Starts the server.
/// This is the entry point for the server.
///
/// dart run bin/server.dart -p 80 -e dev -d :memory: -i 0
void main([List<String>? arguments]) => Future<void>.sync(() async {
      final (:Config config, :Map<String, Object?> context) = await $initializeServer(arguments: arguments);
      l.i('Starting server at ${config.host.host}:${config.port} in ${config.environment.name} mode');

      // ignore: unused_local_variable
      final database = context['database'] as Database;

      await Future<void>.delayed(const Duration(seconds: 10));
      l.s('Fine');
      io.exit(0);

      // TODO(plugfox): collect logs

      //print('Serving at http://${server.address.host}:${server.port}');
    });
