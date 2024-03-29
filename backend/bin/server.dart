import 'dart:async';
import 'dart:convert';

import 'package:backend/src/common/config/config.dart';
import 'package:backend/src/common/config/initialization.dart';
import 'package:backend/src/common/medium/article_dao.dart';
import 'package:backend/src/common/medium/medium.dart';
import 'package:backend/src/common/server/worker.dart';
import 'package:http/http.dart' as http;
import 'package:l/l.dart';

/// Starts the server.
/// This is the entry point for the server.
///
/// dart run bin/server.dart -p 80 -e dev -d :memory: -i 0
void main([List<String>? arguments]) => Future<void>.sync(() async {
      // Log options by default
      final logOption = LogOptions(
        handlePrint: true,
        outputInRelease: true,
        printColors: false,
        overrideOutput: (event) => event.level.level > 1 ? null : event.message.toString(), // Disable default output
      );

      // Initialize the server
      final result = await l.capture(
        () => $initializeServer(arguments: arguments),
        logOption,
      );
      final InitializationProgress(:config, :database) = result;

      // Start the server with multiple workers
      await l.capture(
        () async {
          // Start workers and wait for them to be ready
          final workers = <SharedWorker>[];
          for (var i = 1; i <= config.workers; i++) {
            final worker = await SharedWorker.spawn(
              config: config,
              database: database,
              label: 'Worker#${i.toString().padLeft(config.workers.toString().length, '0')}',
              onMessage: (message) {/* Message from worker */},
            );
            workers.add(worker);
          }

          // Periodic tasks
          if (config.interval > 0 && config.username.isNotEmpty) {
            final medium = Medium(client: http.Client());
            final dao = ArticleDAO(database: database);
            Timer.periodic(
              Duration(seconds: config.interval),
              (_) => medium.fetchArticlesRSS(config.username).then<void>(dao.upsertArticlesIntoDatabase).ignore(),
            );
          }

          // Log server info
          l
            ..i('Started ${workers.length} worker(s) at '
                '${config.address.host}:${config.port} in '
                '${config.environment.name} mode')
            ..i('Press [Ctrl] + [C] to exit');
        },
        LogOptions(
          handlePrint: logOption.handlePrint,
          outputInRelease: logOption.outputInRelease,
          printColors: logOption.printColors,
          messageFormatting: logOption.messageFormatting,
          overrideOutput: _logPrinter(config),
        ),
      );
    });

final Converter<Map<String, Object?>, String> _jsonEncoder = const JsonEncoder().cast<Map<String, Object?>, String>();
String? Function(LogMessage) _logPrinter(Config config) => switch (config.environment) {
      // Production JSON log printer
      EnvironmentFlavor.production => (event) => event.level.level > config.verbose
          ? null
          : _jsonEncoder.convert(<String, Object?>{
              'timestamp': event.timestamp.millisecondsSinceEpoch,
              'level': event.level.toString(),
              'message': event.message.toString(),
              if (event case LogMessageError(:StackTrace stackTrace)) 'stacktrace': stackTrace.toString(),
              if (event.context.isNotEmpty) 'context': event.context,
            }),
      // Development pretty log printer
      _ => (event) => event.level.level > config.verbose
          ? null
          : '[${event.level.prefix}] '
              '${event.timestamp.hour.toString().padLeft(2, '0')}:'
              '${event.timestamp.minute.toString().padLeft(2, '0')}:'
              '${event.timestamp.second.toString().padLeft(2, '0')} | '
              '${switch (event.message.toString()) {
              String msg when msg.length > 100 => '${msg.substring(0, 100 - 4)} ...',
              String msg => msg,
            }}',
    };
