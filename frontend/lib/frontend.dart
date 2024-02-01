library frontend;

import 'dart:html' as html;
import 'dart:js' as js;

import 'package:frontend/src/common/router/router.dart' as r;
import 'package:frontend/src/common/router/routes.dart' as r;
import 'package:frontend/src/feature/articles/controller/articles_controller.dart';
import 'package:frontend/src/feature/articles/data/articles_repository.dart';
import 'package:http/browser_client.dart' as http;

/// Router
final r.Router $router = () {
  // Add router element if not present
  if (html.document.getElementsByTagName('router').whereType<html.Element>().isEmpty) {
    html.document.body?.append(html.Element.tag('router'));
  }
  return r.Router(r.onRoute);
}();

/// Configuration
final $config = () {
  final jsConfig = js.context['config'];
  if (jsConfig == null) return <String, String>{};
  String? extractValue(String key) {
    try {
      if (jsConfig[key] case String value) return value;
    } on Object {/* ignore */}
    return null;
  }

  return <String, String?>{
    'environment': extractValue('environment'),
    'api': extractValue('api'),
    'title': extractValue('title'),
  };
}();

/// API URL
final String $api = $config['api'] ?? (throw Exception('API not set'));

/// API URL
final String $title = $config['title'] ?? 'Unknown';

/// Is development environment
final bool $development = $config['environment']?.toLowerCase() == 'development';

/// Is production environment
final bool $production = !$development;

final IArticlesRepository $articlesRepository = ArticlesRepositoryImpl(
  client: http.BrowserClient(),
  baseUrl: $api,
);

/// Articles controller
final ArticlesController $articlesController = ArticlesController(
  repository: $articlesRepository,
);
