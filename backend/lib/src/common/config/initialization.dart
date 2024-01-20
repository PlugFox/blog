import 'dart:async';
import 'dart:io' as io;
import 'dart:math' as math;

import 'package:backend/src/common/config/app_metadata.dart';
import 'package:backend/src/common/config/app_migrator.dart';
import 'package:backend/src/common/config/config.dart';
import 'package:backend/src/common/database/database.dart';
import 'package:backend/src/common/util/error_util.dart';
import 'package:backend/src/common/util/log_buffer.dart';
import 'package:l/l.dart';

typedef InitializationResult = ({Config config, Map<String, Object?> context});

/// Ephemerally initializes the app and prepares it for use.
FutureOr<InitializationResult>? _$initializeServer;

/// Initializes the server and prepares it for use.
FutureOr<InitializationResult> $initializeServer({
  List<String>? arguments,
  void Function(int progress, String message)? onProgress,
  FutureOr<void> Function(InitializationResult result)? onSuccess,
  void Function(Object error, StackTrace stackTrace)? onError,
}) =>
    _$initializeServer ??= Future<InitializationResult>.sync(() async {
      l.v6('Initialization | Start');
      final stopwatch = Stopwatch()..start();
      try {
        final config = _$initializeServer$Config(arguments);
        final context =
            await _$initializeServer$Steps(config: config, onProgress: onProgress).timeout(const Duration(minutes: 15));
        final result = (config: config, context: context);
        await onSuccess?.call(result);
        return result;
      } on Object catch (error, stackTrace) {
        onError?.call(error, stackTrace);
        ErrorUtil.logError(error, stackTrace, hint: 'Failed to initialize app').ignore();
        rethrow;
      } finally {
        stopwatch.stop();
        _$initializeServer = null;
      }
    });

/// Get the config from the command line arguments and environment variables.
Config _$initializeServer$Config(List<String>? arguments) {
  final parser = Config.argParser(); // Create a parser for the config.

  // Parse the command line arguments
  l.v6('Initialization | Parse command line arguments');
  final result = parser.parse(<String>[
    if (arguments != null)
      for (final a in arguments)
        if (a.isNotEmpty) a.trim().toLowerCase(),
  ]);

  if (result.wasParsed('help')) {
    l.s(parser.usage);
    io.sleep(const Duration(milliseconds: 250));
    io.exit(0); // Exit with success on help.
  }

  // Create a table of --dart-define arguments.
  const defaultConfig = <String, String>{
    'environment': String.fromEnvironment('environment'),
    'address': String.fromEnvironment('address', defaultValue: '0.0.0.0'),
    'port': String.fromEnvironment('port', defaultValue: '8080'),
    'database': String.fromEnvironment('database', defaultValue: 'db.sqlite'),
    'interval': String.fromEnvironment('interval', defaultValue: '3600'),
    'workers': String.fromEnvironment('workers'),
    'token': String.fromEnvironment('token'),
    'verbose': String.fromEnvironment('verbose'),
  };

  // Create a table of --dart-define arguments.
  l.v6('Initialization | Create table of --dart-define arguments');
  final table = <String, String>{
    for (final e in defaultConfig.entries)
      if (e.value.isNotEmpty) e.key: e.value,
  };

  // Add environment variables.
  l.v6('Initialization | Load environment variables');
  final environment = io.Platform.environment;
  for (final o in parser.options.entries) {
    final allias = <String>[o.key, ...o.value.aliases];
    for (final a in allias) {
      if (environment[a] case String value) {
        value = value.toLowerCase().trim();
        if (value.isEmpty) continue;
        table[o.key] = value;
      }
    }
  }

  // Add parsed arguments.
  l.v6('Initialization | Merge parsed arguments');
  for (final o in result.options) table[o] = result[o].toString();

  // Get the value of an environment variable.
  T env<T>(String key, T? Function(String value) parse, T Function() or) {
    try {
      return switch (table[key]) {
            String value => parse(value),
            _ => null,
          } ??
          or();
    } on Object {
      l.w('Initialization | Failed to parse environment variable "$key"');
      return or();
    }
  }

  // Return the config.
  l.v6('Initialization | Recieve config');
  return Config(
    environment: env<EnvironmentFlavor>(
      'environment',
      EnvironmentFlavor.from,
      () =>
          const bool.fromEnvironment('dart.vm.product') ? EnvironmentFlavor.production : EnvironmentFlavor.development,
    ),
    address: env<io.InternetAddress>(
      'address',
      (s) => switch (s.trim().toLowerCase()) {
        '127.0.0.1' || 'loopback' || 'localhost' || 'loopbackipv4' || 'loopback4' => io.InternetAddress.loopbackIPv4,
        'loopbackipv6' || 'loopback6' || 'localhost6' => io.InternetAddress.loopbackIPv6,
        '0.0.0.0' || 'anyipv4' || 'ipv4' || 'ip4' || 'any' || '4' || '' => io.InternetAddress.anyIPv4,
        'anyipv6' || 'ipv6' || 'ip6' || '6' => io.InternetAddress.anyIPv6,
        String address => io.InternetAddress.tryParse(address),
      },
      () => io.InternetAddress.anyIPv4,
    ),
    port: env<int>(
      'port',
      int.tryParse,
      () => 8080,
    ).clamp(1, 65535),
    database: switch (env<String>(
      'database',
      (value) => value,
      () => 'db.sqlite',
    ).trim().toLowerCase()) {
      ':memory:' => ':memory:',
      String name when name.isEmpty => 'db.sqlite',
      String name when name.endsWith('.sqlite') => name,
      String name => '$name.sqlite',
    },
    interval: math.max(
      env<int>(
        'interval',
        int.tryParse,
        () => 3600,
      ),
      0,
    ),
    workers: math.max(
      env<int>(
        'workers',
        int.tryParse,
        () => io.Platform.numberOfProcessors * 2,
      ),
      1,
    ),
    token: switch (env('token', (value) => value, () => '').trim()) {
      String token when token.isEmpty => null,
      String token when token.length < 6 => null,
      String token => token,
    },
    verbose: env<int>(
      'verbose',
      int.tryParse,
      () => 3,
    ).clamp(0, 6),
  );
}

/// Initializes the server and returns a [Config] object
Future<Map<String, Object?>> _$initializeServer$Steps({
  required Config config,
  void Function(int progress, String message)? onProgress,
}) async {
  final totalSteps = _initializationSteps.length;
  var currentStep = 0;
  final context = <String, Object?>{};
  for (final step in _initializationSteps.entries) {
    try {
      currentStep++;
      final percent = (currentStep * 100 ~/ totalSteps).clamp(0, 100);
      onProgress?.call(percent, step.key);
      l.v6('Initialization | $currentStep/$totalSteps ($percent%) | "${step.key}"');
      await step.value(config, context);
    } on Object catch (error, stackTrace) {
      l.e('Initialization failed at step "${step.key}": $error', stackTrace);
      Error.throwWithStackTrace('Initialization failed at step "${step.key}": $error', stackTrace);
    }
  }
  return context;
}

typedef _InitializationStep = FutureOr<void> Function(Config config, Map<String, Object?> context);
final Map<String, _InitializationStep> _initializationSteps = <String, _InitializationStep>{
  'Creating app metadata': (config, context) => AppMetadata(),
  'igint: Ctrl + C': (config, context) {
    void signalHandler(io.ProcessSignal signal) => io.exit(0);
    // SIGTERM is not supported on Windows.
    // Attempting to register a SIGTERM handler raises an exception.
    if (!io.Platform.isWindows) io.ProcessSignal.sigterm.watch().listen(signalHandler, cancelOnError: false);
    io.ProcessSignal.sigint.watch().listen(signalHandler, cancelOnError: false);
  },
  'Connect to database': (config, context) async {
    final database = config.database == ':memory:' ? Database.memory() : Database.lazy(file: io.File(config.database));
    await database.refresh();
    context['database'] = database;
  },
  'Shrink database': (config, context) async {
    final database = context['database'] as Database;
    await database.customStatement('VACUUM;');
    await database.transaction(() async {
      final log = await (database.select<LogTbl, LogTblData>(database.logTbl)
            ..orderBy([(tbl) => OrderingTerm(expression: tbl.id, mode: OrderingMode.desc)])
            ..limit(1, offset: 1000))
          .getSingleOrNull();
      if (log != null) {
        await (database.delete(database.logTbl)..where((tbl) => tbl.timestamp.isSmallerOrEqualValue(log.timestamp)))
            .go();
      }
    });
    if (DateTime.now().second % 10 == 0) await database.customStatement('VACUUM;');
  },
  'Migrate app from previous version': (config, context) async {
    final database = context['database'] as Database;
    await AppMigrator.migrate(database);
  },
  // --- Last step --- //
  'Collect logs': (config, context) async {
    final database = context['database'] as Database;
    await (database.select<LogTbl, LogTblData>(database.logTbl)
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.timestamp, mode: OrderingMode.desc)])
          ..limit(LogBuffer.bufferLimit))
        .get()
        .then<List<LogMessage>>((logs) => logs
            .map((l) => switch (l.stacktrace) {
                  String stacktrace => LogMessage.error(
                      timestamp: DateTime.fromMillisecondsSinceEpoch(l.timestamp * 1000),
                      level: LogLevel.fromValue(l.level),
                      message: l.message,
                      stackTrace: StackTrace.fromString(stacktrace)),
                  null => LogMessage.verbose(
                      timestamp: DateTime.fromMillisecondsSinceEpoch(l.timestamp * 1000),
                      level: LogLevel.fromValue(l.level),
                      message: l.message,
                    )
                })
            .toList())
        .then<void>(LogBuffer.instance.addAll);

    final logsCache = <LogMessage>[];
    l.listen(
      (log) {
        LogBuffer.instance.add(log);
        logsCache.add(log);
      },
      onError: (error, stackTrace) {/* ignore */},
      cancelOnError: false,
    );

    final timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (logsCache.isEmpty) return;
      final logs = logsCache
          .map<LogTblCompanion>((log) => LogTblCompanion.insert(
                level: log.level.level,
                message: log.message.toString(),
                timestamp: Value<int>(log.timestamp.millisecondsSinceEpoch ~/ 1000),
                stacktrace: Value<String?>(switch (log) { LogMessageError l => l.stackTrace.toString(), _ => null }),
              ))
          .toList(growable: false);
      logsCache.clear();
      database.batch((batch) => batch.insertAll(database.logTbl, logs)).ignore();
    });

    context['log_buffer'] = LogBuffer.instance;
    context['log_collector'] = timer;
  },
};
