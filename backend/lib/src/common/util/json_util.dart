// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:convert';

import 'package:shelf/shelf.dart' as shelf;

final Converter<String, Map<String, Object?>> _decoder = const JsonDecoder().cast<String, Map<String, Object?>>();

/// Utility class for working with JSON.
sealed class JsonUtil {
  /// Convert [value] to JSON Object (Map<String, Object?>).
  static Map<String, Object?> jsonDecode(String value) => _decoder.convert(value);

  /// Extracts a value from [json] and casts it to [T].
  static T extract<T>(Map<String, Object?> json, String key, [T? fallback]) {
    if (json[key] case T value) return value;
    if (fallback is T) return fallback;
    throw ArgumentError.value(json[key], 'value', 'is not of type $T');
  }

  /// Extracts a value from [json] and casts it to [T] by [keys].
  static T extractAny<T>(Map<String, Object?> json, Iterable<String> keys, [T? fallback]) {
    for (final key in keys) if (json[key] case T value) return value;
    if (fallback is T) return fallback;
    throw ArgumentError('No value of type $T found in $keys');
  }

  /// Extracts a value from [json] and casts it to [T].
  /// Returns `null` if the value is not of type [T].
  static T? extractOrNull<T>(Map<String, Object?> json, String key) {
    if (json[key] case T value) return value;
    return null;
  }

  /// Extracts a value from [json] and casts it to [DateTime].
  /// [String] - [DateTime] format: `yyyy-MM-ddTHH:mm:ss.SSSZ`
  /// [int] - [DateTime] format: seconds since epoch
  static DateTime? extractDateTimeOrNull(Map<String, Object?> json, String key) => switch (json[key]) {
        String value => DateTime.tryParse(value)?.toUtc(),
        int value => DateTime.fromMillisecondsSinceEpoch(value * 1000, isUtc: true),
        _ => null,
      };

  /// Try to extract a Map<String, Object?>.
  static Map<String, Object?>? extractObjectOrNull(Map<String, Object?> json, String key) =>
      extractOrNull<Map<String, Object?>>(json, key);
}

extension JsonUtilX on Map<String, Object?> {
  /// Extracts a value from [this] and casts it to [T].
  T extract<T>(String key, [T? fallback]) => JsonUtil.extract<T>(this, key, fallback);

  /// Extracts a value from [json] and casts it to [T] by [keys].
  T extractAny<T>(Iterable<String> keys, [T? fallback]) => JsonUtil.extractAny<T>(this, keys, fallback);

  /// Extracts a value from [this] and casts it to [T].
  /// Returns `null` if the value is not of type [T].
  T? extractOrNull<T>(String key) => JsonUtil.extractOrNull<T>(this, key);

  /// Extracts a value from [this] and casts it to [DateTime].
  /// [String] - [DateTime] format: `yyyy-MM-ddTHH:mm:ss.SSSZ`
  /// [int] - [DateTime] format: seconds since epoch
  DateTime? extractDateTimeOrNull(String key) => JsonUtil.extractDateTimeOrNull(this, key);

  /// Try to extract a Map<String, Object?> from [this].
  Map<String, Object?>? extractObjectOrNull(String key) => JsonUtil.extractObjectOrNull(this, key);
}

extension StringToJsonObjectX on String {
  /// Convert to JSON Object (Map<String, Object?>).
  Map<String, Object?> toJson() => JsonUtil.jsonDecode(this);
}

extension RequestToJsonObjectX on shelf.Request {
  /// Convert to JSON Object (Map<String, Object?>).
  Future<Map<String, Object?>> toJson() => readAsString().then<Map<String, Object?>>(JsonUtil.jsonDecode);
}
