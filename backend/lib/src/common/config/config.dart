import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:meta/meta.dart';

/// {@template config}
/// The configuration of the server.
/// {@endtemplate}
@immutable
final class Config {
  /// {@macro config}
  const Config({
    required this.environment,
    required this.host,
    required this.port,
    required this.database,
    required this.interval,
    required this.workers,
  });

  /// Create a [ArgParser] for the [Config].
  static ArgParser argParser() => ArgParser()
    ..addOption(
      'environment',
      abbr: 'e',
      aliases: ['env', 'flavor', 'mode'],
      help: 'The environment to run in.',
      defaultsTo: const bool.fromEnvironment('dart.vm.product') ? 'production' : 'development',
    )
    ..addOption(
      'host',
      abbr: 'a',
      aliases: ['address', 'addr', 'ip', 'interface', 'if'],
      help: 'The host/address to listen on.',
      defaultsTo: '0.0.0.0',
    )
    ..addOption(
      'port',
      abbr: 'p',
      help: 'The port to listen on.',
      defaultsTo: '8080',
    )
    ..addOption(
      'database',
      abbr: 'd',
      aliases: ['db', 'file', 'path', 'location', 'sqlite', 'sqlite3', 'cache', 'storage'],
      help: 'The SQLite database file path.',
      defaultsTo: 'db.sqlite',
    )
    ..addOption(
      'interval',
      abbr: 'i',
      aliases: ['timer', 'check', 'refresh', 'update', 'fetch', 'refetch', 'fetching', 'medium', 'cron'],
      help: 'The number of seconds between each medium articles check.',
      defaultsTo: '3600',
    )
    ..addOption(
      'workers',
      abbr: 'w',
      aliases: ['threads', 'cores', 'processors', 'cpus', 'cpu', 'parallel', 'concurrent', 'isolates', 'concurrency'],
      help: 'The number of workers to spawn.',
      defaultsTo: '${io.Platform.numberOfProcessors * 2}',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      aliases: <String>['?', 'usage', 'info', 'man', 'manual', 'guide', 'reference'],
      help: 'Print this usage information.',
      negatable: false,
    );

  /// The environment to run in.
  final EnvironmentFlavor environment;

  /// The host to listen on.
  final io.InternetAddress host;

  /// The port to listen on.
  final int port;

  /// The SQLite database file path.
  final String database;

  /// The number of seconds between each
  /// medium articles check.
  ///
  /// Default value is 3600 seconds (1 hour).
  ///
  /// 0 means no check.
  final int interval;

  /// The number of workers to spawn.
  /// Default value is equal to the number of processors * 2.
  final int workers;
}

/// Environment flavor.
/// e.g. development, staging, production
enum EnvironmentFlavor {
  /// Development
  development('development'),

  /// Staging
  staging('staging'),

  /// Production
  production('production');

  /// {@nodoc}
  const EnvironmentFlavor(this.name);

  /// {@nodoc}
  factory EnvironmentFlavor.from(String? name) => switch (name?.trim().toLowerCase()) {
        'development' || 'debug' || 'local' || 'develop' || 'dev' || 'lcl' => development,
        'staging' || 'profile' || 'preview' || 'stage' || 'stg' => staging,
        'production' || 'release' || 'live' || 'prod' || 'prd' => production,
        _ => const bool.fromEnvironment('dart.vm.product') ? production : development,
      };

  /// development, staging, production
  final String name;

  /// Whether the environment is development.
  bool get isDevelopment => this == development;

  /// Whether the environment is staging.
  bool get isStaging => this == staging;

  /// Whether the environment is production.
  bool get isProduction => this == production;

  @override
  String toString() => name;
}
