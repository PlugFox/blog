import 'dart:io' as io;

import 'package:backend/src/common/config/pubspec.yaml.g.dart';
import 'package:meta/meta.dart';

/// {@template app_metadata}
/// App metadata
/// {@endtemplate}
@immutable
final class AppMetadata {
  static final AppMetadata _internalSingleton = AppMetadata._internal(
    isRelease: const bool.fromEnvironment('dart.vm.product'),
    appVersion: Pubspec.version.representation,
    appVersionMajor: Pubspec.version.major,
    appVersionMinor: Pubspec.version.minor,
    appVersionPatch: Pubspec.version.patch,
    appBuildTimestamp: Pubspec.timestamp.toUtc(),
    appName: Pubspec.name,
    operatingSystem: io.Platform.operatingSystem,
    processorsCount: io.Platform.numberOfProcessors,
    locale: io.Platform.localeName,
    deviceVersion: io.Platform.operatingSystemVersion,
    appLaunchedTimestamp: DateTime.now(),
  );
  factory AppMetadata() => _internalSingleton;

  /// {@macro app_metadata}
  const AppMetadata._internal({
    required this.isRelease,
    required this.appVersion,
    required this.appVersionMajor,
    required this.appVersionMinor,
    required this.appVersionPatch,
    required this.appBuildTimestamp,
    required this.appName,
    required this.operatingSystem,
    required this.processorsCount,
    required this.locale,
    required this.deviceVersion,
    required this.appLaunchedTimestamp,
  });

  /// Is release build
  final bool isRelease;

  /// App version
  final String appVersion;

  /// App version major
  final int appVersionMajor;

  /// App version minor
  final int appVersionMinor;

  /// App version patch
  final int appVersionPatch;

  /// App build timestamp
  final DateTime appBuildTimestamp;

  /// App name
  final String appName;

  /// Operating system
  final String operatingSystem;

  /// Processors count
  final int processorsCount;

  /// Locale
  final String locale;

  /// Device representation
  final String deviceVersion;

  /// App launched timestamp
  final DateTime appLaunchedTimestamp;

  /// Convert to headers
  Map<String, String> toHeaders() => <String, String>{
        'X-Meta-Is-Release': isRelease ? 'true' : 'false',
        'X-Meta-App-Version': appVersion,
        'X-Meta-App-Version-Major': appVersionMajor.toString(),
        'X-Meta-App-Version-Minor': appVersionMinor.toString(),
        'X-Meta-App-Version-Patch': appVersionPatch.toString(),
        'X-Meta-App-Build-Timestamp': appBuildTimestamp.toString(),
        'X-Meta-App-Name': appName,
        'X-Meta-Operating-System': operatingSystem,
        'X-Meta-Processors-Count': processorsCount.toString(),
        'X-Meta-Locale': locale,
        'X-Meta-Device-Version': deviceVersion,
        'X-Meta-App-Launched-Timestamp': appLaunchedTimestamp.millisecondsSinceEpoch.toString(),
      };
}
