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
    required this.address,
    required this.port,
    required this.database,
    required this.interval,
    required this.workers,
    required this.token,
    required this.verbose,
    required this.username,
  });

  /// Create a [ArgParser] for the [Config].
  static ArgParser argParser() => ArgParser()
    ..addSeparator('Start server to provide medium articles as Protobuf API.')
    ..addSeparator('Server options:\n')
    ..addOption(
      'environment',
      abbr: 'e',
      aliases: ['env', 'flavor', 'mode'],
      help: 'The environment to run in.',
      defaultsTo: const bool.fromEnvironment('dart.vm.product') ? 'production' : 'development',
    )
    ..addOption(
      'address',
      abbr: 'a',
      aliases: ['host', 'addr', 'ip', 'interface', 'if'],
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
      help: 'The SQLite database file path.\n'
          'Provide ":memory:" to use an in-memory database.',
      defaultsTo: 'db.sqlite',
    )
    ..addOption(
      'interval',
      abbr: 'i',
      aliases: ['timer', 'check', 'refresh', 'update', 'fetch', 'refetch', 'fetching', 'cron'],
      help: 'The number of seconds between each medium articles check.',
      defaultsTo: '86400',
    )
    ..addOption(
      'workers',
      abbr: 'w',
      aliases: ['threads', 'cores', 'processors', 'cpus', 'cpu', 'parallel', 'concurrent', 'isolates', 'concurrency'],
      help: 'The number of workers to spawn.',
      defaultsTo: '${io.Platform.numberOfProcessors.clamp(1, 14)}',
    )
    ..addOption(
      'token',
      abbr: 't',
      aliases: ['token', 'admin', 'secret', 'key', 'password', 'pass', 'auth', 'authentication', 'authorization'],
      help: 'The secret token to use for authentication.\n'
          'If not provided, authentication will be disabled.\n'
          'Should be at least 6 characters long.',
      defaultsTo: '',
    )
    ..addOption(
      'username',
      abbr: 'u',
      aliases: ['author', 'medium', 'medium-username', 'medium-user', 'medium-author', 'handle'],
      help: 'Medium username.\n'
          'The author of the articles.',
      defaultsTo: const String.fromEnvironment('USERNAME', defaultValue: 'plugfox'),
    )
    ..addOption(
      'verbose',
      abbr: 'v',
      aliases: ['verbosity', 'log', 'logging', 'debug'],
      help: 'The verbose level.\n'
          ' Set to 0 to disable logging.\n'
          ' Set to 1 to log only errors.\n'
          ' Set to 2 to log errors and warnings.\n'
          ' Set to 3 to log errors, warnings and info.\n'
          ' Set to 4 to log errors, warnings, info and debug.\n'
          ' Set to 5 to log all minor details.\n'
          ' Set to 6 to log everything.',
      defaultsTo: '3',
    )
    ..addSeparator('')
    ..addFlag(
      'help',
      abbr: 'h',
      aliases: <String>['?', 'usage', 'info', 'man', 'manual', 'guide', 'reference'],
      help: 'Print this usage information.',
      negatable: false,
    )
    ..addSeparator('');

  /// The environment to run in.
  final EnvironmentFlavor environment;

  /// The address to listen on.
  final io.InternetAddress address;

  /// The port to listen on.
  final int port;

  /// The SQLite database file path.
  final String database;

  /// The number of seconds between each
  /// medium articles check.
  ///
  /// Default value is 86400 seconds (1 day).
  ///
  /// 0 means no check.
  final int interval;

  /// The number of workers to spawn.
  /// Default value is equal to the number of processors,
  /// clamped between 1 and 14.
  final int workers;

  /// The secret token to use for authentication.
  final String? token;

  /// The verbose level.
  /// The verbose level. Set to 0 to disable logging.
  /// Set to 1 to log only errors and major messages.
  /// Set to 2 to log errors and warnings.
  /// Set to 3 to log errors, warnings and info.
  /// Set to 4 to log errors, warnings, info and debug.
  /// Set to 5 to log all minor details.
  /// Set to 6 to log everything.
  final int verbose;

  /// Medium username.
  /// The author of the articles.
  final String username;
}

/// {@template environment_flavor}
/// Environment flavor.
/// e.g. development, staging, production
/// {@endtemplate}
enum EnvironmentFlavor {
  /// Development
  development('development'),

  /// Staging
  staging('staging'),

  /// Production
  production('production');

  /// {@macro environment_flavor}
  const EnvironmentFlavor(this.name);

  /// {@macro environment_flavor}
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
