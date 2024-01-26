import 'dart:html' as html;

import 'package:frontend/src/common/config/pubspec.yaml.g.dart';
import 'package:meta/meta.dart';

/// {@template app_metadata}
/// App metadata singleton.
/// {@endtemplate}
@immutable
final class AppMetadata {
  static final AppMetadata _internalSingleton = AppMetadata._internal(
    version: Pubspec.version,
    built: Pubspec.timestamp.toUtc(),
    name: Pubspec.name,
    agent: html.window.navigator.userAgent,
    language: html.window.navigator.language,
    launched: DateTime.now(),
  );

  /// {@macro app_metadata}
  factory AppMetadata() => _internalSingleton;

  const AppMetadata._internal({
    required this.version,
    required this.built,
    required this.name,
    required this.agent,
    required this.language,
    required this.launched,
  });

  /// App name
  final String name;

  /// App version
  final PubspecVersion version;

  /// App timestamp
  final DateTime built;

  /// User agent string
  final String agent;

  /// Language
  final String language;

  /// App launched timestamp
  final DateTime launched;

  /// Convert to headers
  Map<String, String> toHeaders() => <String, String>{
        'X-Meta-Name': name,
        'X-Meta-Version': version.representation,
        'X-Meta-Built': built.toUtc().toIso8601String(),
        'X-Meta-Agent': agent,
        'X-Meta-Language': language,
        'X-Meta-Launched': launched.toUtc().toIso8601String(),
      };
}
