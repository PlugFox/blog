import 'dart:async';
import 'dart:io' as io;
import 'dart:isolate';

import 'package:backend/src/common/config/config.dart';
import 'package:backend/src/common/database/database.dart';
import 'package:backend/src/routes/serve.dart';
import 'package:l/l.dart';
import 'package:meta/meta.dart';

/// The arguments for the isolate with the shelf server.
@immutable
final class _SharedWorkerArguments {
  const _SharedWorkerArguments({
    required this.send,
    required this.config,
    required this.db,
    required this.label,
  });

  /// The port for the worker.
  final SendPort send;

  /// Server configuration.
  final Config config;

  /// The database connection.
  final TransferableDatabaseConnection db;

  /// The label of the worker.
  final String? label;
}

/// {@template shared_worker}
/// The shared worker.
/// {@endtemplate}
final class SharedWorker {
  SharedWorker._();

  SendPort? _sendPort;
  Isolate? _isolate;

  /// Sends a message to the worker.
  void add(Object message) {
    if (_sendPort == null) throw StateError('Worker is not running');
    _sendPort?.send(message);
  }

  /// Spawns a new worker.
  ///
  /// {@macro shared_worker}
  static Future<SharedWorker> spawn({
    required Database database,
    required Config config,
    String? label,
    void Function(Object message)? onMessage,
  }) async {
    final receivePort = ReceivePort();
    final worker = SharedWorker._();
    final completer = Completer<void>.sync();
    void onError(Object error, StackTrace stackTrace) {
      receivePort.close();
      worker._sendPort = null;
      worker._isolate?.kill();
      worker._isolate = null;
      l.e('FATAL ERROR ${label != null ? 'AT "$label" ' : ''}| $error', stackTrace);
      database.close().ignore();
      io.sleep(const Duration(milliseconds: 250));
      io.exit(2);
    }

    receivePort.listen(
      (message) {
        switch (message) {
          case LogMessage event:
            l.log(event);
          case SendPort port:
            worker._sendPort = port;
            if (!completer.isCompleted) completer.complete();
          case [Object error, StackTrace? stackTrace]:
            onError(
              error,
              stackTrace ?? StackTrace.empty,
            );
          case [Object error, String? stackTrace]:
            onError(
              error,
              switch (stackTrace) {
                String string when string.isNotEmpty => StackTrace.fromString(string),
                _ => StackTrace.empty,
              },
            );
          case null:
            onError(StateError('Worker died unexpectedly'), StackTrace.current);
          case Object obj:
            onMessage?.call(obj);
        }
      },
      cancelOnError: false,
    );
    final db = await database.transferableDatabaseConnection;
    worker._isolate = await Isolate.spawn<_SharedWorkerArguments>(
      _endpoint,
      _SharedWorkerArguments(
        send: receivePort.sendPort,
        config: config,
        db: db,
        label: label,
      ),
      debugName: label,
      errorsAreFatal: true,
    );
    await completer.future;
    await Future<void>.delayed(Duration.zero);
    return worker;
  }

  /// The entry point for the isolate.
  static void _endpoint(_SharedWorkerArguments args) {
    void send(Object message) => args.send.send(message);
    l.capture<void>(
      () => runZonedGuarded<void>(
        () async {
          final receivePort = ReceivePort()
            ..listen(
              (message) {/* ... */},
              cancelOnError: false,
            );
          final database = await Database.connect(args.db);
          await serve(config: args.config, database: database);
          send(receivePort.sendPort); // send port to main isolate from current isolate
          l.i('Started worker "${args.label}"');
        },
        (error, stackTrace) => send([error.toString(), stackTrace]),
      ),
      LogOptions(
        handlePrint: true,
        outputInRelease: true,
        printColors: false,
        overrideOutput: (event) {
          send(event);
          return null;
        },
      ),
    );
  }
}
