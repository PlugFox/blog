library frontend;

import 'dart:html' as html;
import 'dart:js' as js;

import 'package:frontend/src/common/router/router.dart' as r;
import 'package:frontend/src/common/router/routes.dart' as r;

/// Router
final r.Router router = () {
  // Add router element if not present
  if (html.document.getElementsByTagName('router').whereType<html.Element>().isEmpty) {
    html.document.body?.append(html.Element.tag('router'));
  }
  return r.Router(r.onRoute);
}();

/// API URL
final String api = config['api'] ?? (throw Exception('API not set'));

/// Is development environment
final bool development = config['environment']?.toLowerCase() == 'development';

/// Is production environment
final bool production = !development;

/// Configuration
final config = () {
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
  };
}();
