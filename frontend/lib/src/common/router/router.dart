// ignore_for_file: use_setters_to_change_properties

import 'dart:async';
import 'dart:html' as html;

import 'package:frontend/src/common/controller/change_notifier.dart';
import 'package:meta/meta.dart';

/// Callback for route change
/// [route] - new route
/// [emit] - function for emitting content
typedef RouteChangeCallback = FutureOr<void> Function(Route route, void Function(Object? content) emit);

/// {@template route}
/// Route representation
/// {@endtemplate}
@immutable
final class Route {
  /// Empty route
  ///
  /// {@macro router}
  const Route.empty()
      : key = '',
        path = '',
        segments = const <String>[],
        params = const <String, String>{};

  /// Route from url
  factory Route.fromUrl(Uri uri) {
    final fragment = uri.fragment;
    var newRoute = fragment.trim().toLowerCase().replaceAll(' ', '');
    if (newRoute.isEmpty) return const Route.empty();
    while (newRoute.startsWith('/') || newRoute.startsWith('#')) newRoute = newRoute.substring(1);
    while (newRoute.endsWith('/') || newRoute.endsWith('#')) newRoute = newRoute.substring(0, newRoute.length - 1);
    return Route(Uri.decodeComponent(newRoute));
  }

  /// {@macro router}
  factory Route(String path) {
    final paramsIndex = path.indexOf('?');
    final params = <String, String>{};
    if (paramsIndex != -1) {
      final paramsString = path.toLowerCase().substring(paramsIndex + 1);
      paramsString.split('&').forEach((param) {
        final keyIndex = param.indexOf('=');
        if (keyIndex == -1) {
          params[param.trim()] = '';
        } else {
          final key = param.substring(0, keyIndex);
          final value = param.substring(keyIndex + 1);
          params[key.trim()] = value.trim();
        }
      });
      params.remove('');
    }
    final segments = (paramsIndex != -1 ? path.substring(0, paramsIndex) : path)
        .toLowerCase()
        .split('/')
        .map((segment) => segment.trim())
        .where((segment) => segment.isNotEmpty)
        .toList(growable: false);

    final normalizedSegments = List<String>.unmodifiable(segments);
    final normalizedParams = Map<String, String>.unmodifiable(params);
    final buffer = StringBuffer(normalizedSegments.firstOrNull ?? '');
    for (var i = 1; i < normalizedSegments.length; i++) buffer.write('/${normalizedSegments[i]}');
    if (normalizedParams.isNotEmpty) {
      final entries = normalizedParams.entries.toList(growable: false)..sort((a, b) => a.key.compareTo(b.key));
      buffer
        ..write('?')
        ..write(entries.first.key)
        ..write('=')
        ..write(entries.first.value);
      for (var i = 1; i < entries.length; i++)
        buffer
          ..write('&')
          ..write(entries[i].key)
          ..write('=')
          ..write(entries[i].value);
    }
    final normalizedPath = buffer.toString();
    return Route._(
      normalizedPath.hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0'),
      normalizedPath,
      normalizedSegments,
      normalizedParams,
    );
  }

  const Route._(
    this.key,
    this.path,
    this.segments,
    this.params,
  );

  /// Hash of the path
  final String key;

  /// Full path/fragment of the route
  /// e.g. for route '/articles/:id?key=value' path will be '/articles/:id?key=value'
  final String path;

  /// Segments of the route
  /// e.g. for route '/articles/:id?key=value' segments will be ['articles', ':id']
  final List<String> segments;

  /// Parameters of the route
  /// e.g. for route '/articles/:id?key=value' params will be {'key': 'value'}
  final Map<String, String> params;

  @override
  int get hashCode => path.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Route && path == other.path;

  @override
  String toString() => path;
}

/// {@template router}
/// Router - object for managing routes
/// {@endtemplate}
final class Router with ChangeNotifier {
  /// {@macro router}
  Router(RouteChangeCallback onRouteChange)
      : _uri = Uri(),
        _currentRoute = const Route.empty(),
        _onRouteChange = onRouteChange {
    _hashChangeSubscription = html.window.onHashChange.listen((_) => _checkRouteChange());
    _popStateSubscription = html.window.onPopState.listen((_) => _checkRouteChange());
    _notifyRouteChange(Uri.tryParse(html.window.location.href) ?? Uri());
  }

  /// Callback for route change
  final RouteChangeCallback _onRouteChange;
  StreamSubscription<html.Event>? _hashChangeSubscription;
  StreamSubscription<html.PopStateEvent>? _popStateSubscription;

  Uri _uri;
  Uri get uri => _uri;
  Route _currentRoute;
  Route get currentRoute => _currentRoute;

  html.Element? _getRouterElement() =>
      html.document.getElementsByTagName('router').whereType<html.Element>().firstOrNull;

  /// Function for check about route change
  void _checkRouteChange() {
    final newUri = Uri.tryParse(html.window.location.href);
    if (newUri == null || uri.fragment == newUri.fragment) return;
    _uri = newUri;
    _notifyRouteChange(uri);
  }

  /// Function for notifying about route change
  void _notifyRouteChange(Uri uri) {
    final newRoute = _currentRoute = Route.fromUrl(uri);
    _onRouteChange(newRoute, (content) {
      if (newRoute != currentRoute) return;
      final routerElement = _getRouterElement();
      if (routerElement == null) return;
      routerElement.children.clear();
      switch (content) {
        case html.Element content:
          routerElement.append(content);
        case html.DocumentFragment content:
          routerElement.append(content);
        case String content:
          routerElement.setInnerHtml(content, validator: html.NodeValidatorBuilder.common()); // ignore: unsafe_html
        case List<html.Element> content:
          final fragment = html.DocumentFragment();
          content.forEach(fragment.append);
          routerElement.append(fragment);
        default:
          return;
      }
    });
    notifyListeners();
  }

  /// Function for setting route
  static void setRoute(String route, String title) {
    final newRoute = Route(route);
    if (html.window.location.hash == newRoute.path) return;
    html.window.location.hash = newRoute.path;
    if (html.document.title != title) html.document.title = title;
    html.window.history.replaceState(null, title, '#${newRoute.path}');
  }

  @override
  void dispose() {
    super.dispose();
    _hashChangeSubscription?.cancel();
    _popStateSubscription?.cancel();
  }
}
