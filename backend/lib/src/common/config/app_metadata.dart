import 'dart:io' as io;

import 'package:backend/src/common/config/pubspec.yaml.g.dart';
import 'package:meta/meta.dart';

/// {@template app_metadata}
/// App metadata singleton.
/// {@endtemplate}
@immutable
final class AppMetadata {
  static final AppMetadata _internalSingleton = AppMetadata._internal(
    debug: !const bool.fromEnvironment('dart.vm.product'),
    version: Pubspec.version,
    built: Pubspec.timestamp.toUtc(),
    name: Pubspec.name,
    os: io.Platform.operatingSystem,
    cpus: io.Platform.numberOfProcessors,
    locale: io.Platform.localeName,
    launched: DateTime.now(),
  );

  /// {@macro app_metadata}
  factory AppMetadata() => _internalSingleton;

  const AppMetadata._internal({
    required this.debug,
    required this.version,
    required this.built,
    required this.name,
    required this.os,
    required this.cpus,
    required this.locale,
    required this.launched,
  });

  /// Is debug mode
  final bool debug;

  /// App name
  final String name;

  /// App version
  final PubspecVersion version;

  /// App timestamp
  final DateTime built;

  /// Operating system
  final String os;

  /// Processors count
  final int cpus;

  /// Locale
  final String locale;

  /// App launched timestamp
  final DateTime launched;

  /// Convert to headers
  Map<String, String> toHeaders() => <String, String>{
        'X-Meta-Debug': debug ? 'true' : 'false',
        'X-Meta-Name': name,
        'X-Meta-Version': version.representation,
        'X-Meta-Built': built.toUtc().toIso8601String(),
        'X-Meta-Operating-System': os,
        'X-Meta-Processors-Count': cpus.toString(),
        'X-Meta-Locale': locale,
        'X-Meta-Launched': launched.toUtc().toIso8601String(),
      };
}
