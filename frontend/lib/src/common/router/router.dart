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
        name = '',
        segments = const <String>[],
        params = const <String, String>{};

  /// {@macro router}
  factory Route(String path) {
    final paramsIndex = path.indexOf('?');
    final params = <String, String>{};
    if (paramsIndex != -1) {
      final paramsString = path.substring(paramsIndex + 1);
      paramsString.split('&').forEach((param) {
        final keyIndex = param.indexOf('=');
        if (keyIndex == -1) {
          params[param] = '';
        } else {
          final key = param.substring(0, keyIndex);
          final value = param.substring(keyIndex + 1);
          params[key] = value;
        }
      });
    }
    final segments = (paramsIndex != -1 ? path.substring(0, paramsIndex) : path)
        .split('/')
        .where((segment) => segment.isNotEmpty)
        .toList(growable: false);

    return Route._(
      path.hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0'),
      path,
      segments.firstOrNull ?? '',
      segments,
      params,
    );
  }

  const Route._(
    this.key,
    this.path,
    this.name,
    this.segments,
    this.params,
  );

  /// Hash of the path
  final String key;

  /// Full path/fragment of the route
  /// e.g. for route '/articles/:id?key=value' path will be '/articles/:id?key=value'
  final String path;

  /// Name of the route
  /// e.g. for route '/articles/:id?key=value' name will be 'articles'
  final String name;

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
    _hashChangeSubscription = html.window.onHashChange.listen((_) => _notifyRouteChange());
    _popStateSubscription = html.window.onPopState.listen((_) => _notifyRouteChange());
    _notifyRouteChange();
  }

  static Route _normalizeRoute(String route) {
    var newRoute = route.trim().toLowerCase().replaceAll(' ', '');
    if (newRoute.isEmpty) return const Route.empty();
    while (newRoute.startsWith('/') || newRoute.startsWith('#')) newRoute = newRoute.substring(1);
    while (newRoute.endsWith('/') || newRoute.endsWith('#')) newRoute = newRoute.substring(0, newRoute.length - 1);
    return Route(newRoute);
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

  /// Function for notifying about route change
  void _notifyRouteChange() {
    final newUri = Uri.tryParse(html.window.location.href);
    if (newUri == null || uri.fragment == newUri.fragment) return;
    _uri = newUri;
    final newRoute = _currentRoute = _normalizeRoute(_uri.fragment);
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
  void setRoute(String route) {
    final newRoute = _normalizeRoute(route);
    if (newRoute == currentRoute) return;
    html.window.location.hash = newRoute.path;
  }

  @override
  void dispose() {
    super.dispose();
    _hashChangeSubscription?.cancel();
    _popStateSubscription?.cancel();
  }
}
