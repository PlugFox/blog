import 'package:backend/src/common/config/config.dart';
import 'package:backend/src/common/database/database.dart';
import 'package:backend/src/common/medium/article_dao.dart';
import 'package:meta/meta.dart';
import 'package:shelf/shelf.dart';

/// Injects a [Map] of dependencies into the request context.
Middleware injector({
  required Config config,
  required Database database,
  required ArticleDAO articleDAO,
  Map<String, Object?>? dependency,
}) =>
    (innerHandler) => (request) => innerHandler(
          request.change(
            context: <String, Object?>{
              ...request.context,
              ...?dependency,
              Dependencies._key: Dependencies._(
                config: config,
                database: database,
                articleDAO: articleDAO,
              ),
            },
          ),
        );

@immutable
final class Dependencies {
  const Dependencies._({
    required this.config,
    required this.database,
    required this.articleDAO,
  });

  static const String _key = '_@DEPENDENCIES';

  factory Dependencies.from(Request request) => request.context[_key] as Dependencies;

  // ignore: unused_element
  void _inject(Request request) => request.change(
        context: <String, Object?>{
          ...request.context,
          _key: this,
        },
      );

  /// Configuration of the server.
  final Config config;

  /// SQLite database.
  final Database database;

  /// Data access object for articles.
  final ArticleDAO articleDAO;
}

// TODO(plugfox): make container with dependencuies
