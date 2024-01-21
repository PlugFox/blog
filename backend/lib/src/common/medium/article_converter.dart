import 'dart:convert';
import 'dart:typed_data';

import 'package:shared/shared.dart';

/// {@template article_converter_csv}
/// Converts an article to a CSV string.
/// {@endtemplate}
final class Article2CSV extends Converter<Article, String> {
  /// {@macro article_converter_csv}
  const Article2CSV();

  static const String _separator = ',';

  /// Add the article to the buffer.
  static void addArticleToBuffer(Article article, StringBuffer buffer) {
    buffer
      ..write(article.id)
      ..write(_separator)
      ..write(DateTime.fromMillisecondsSinceEpoch(article.createdAt * 1000))
      ..write(_separator)
      ..write(DateTime.fromMillisecondsSinceEpoch(article.updatedAt * 1000))
      ..write(_separator)
      ..write(article.title)
      ..writeln();
  }

  @override
  String convert(Article input) {
    final buffer = StringBuffer('');
    addArticleToBuffer(input, buffer);
    return buffer.toString();
  }
}

/// {@template article_converter_json}
/// Converts an article to a JSON string.
/// {@endtemplate}
final class Article2JSON extends Converter<Article, Map<String, Object?>> {
  /// {@macro article_converter_json}
  const Article2JSON();

  @override
  Map<String, Object?> convert(Article input) => input.toProto3Json() as Map<String, Object?>;
}

/// {@template article_converter_bytes}
/// Converts an article to a byte array.
/// {@endtemplate}
final class Article2Bytes extends Converter<Article, Uint8List> {
  /// {@macro article_converter_bytes}
  const Article2Bytes();

  @override
  Uint8List convert(Article input) => input.writeToBuffer();
}
