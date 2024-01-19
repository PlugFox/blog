import 'dart:io' as io;

import 'package:backend/src/common/config/config.dart';
import 'package:backend/src/common/config/initialization.dart';
import 'package:backend/src/common/database/database.dart';
import 'package:l/l.dart';

void main(List<String> args) => Future<void>.sync(() async {
      final (:Config config, :Map<String, Object?> context) = await $initializeServer(arguments: args);
      l.i('Starting server at ${config.host.host}:${config.port} in ${config.environment.name} mode');

      // ignore: unused_local_variable
      final database = context['database'] as Database;

      l.s('Fine');
      io.exit(0);

      //print('Serving at http://${server.address.host}:${server.port}');
    });
