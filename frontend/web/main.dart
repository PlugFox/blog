import 'dart:async';
import 'dart:developer';
import 'dart:html' as html;

import 'package:frontend/src/common/router/router.dart';

void main() => runZonedGuarded<Future<void>>(
      () async {
        runApp();
      },
      (error, stackTrace) => log(
        'Top level exception',
        error: error,
        stackTrace: stackTrace,
        level: 1000,
        name: 'main',
      ),
    );

void runApp() => Future<void>(() async {
      if (html.document.readyState?.trim().toLowerCase() != 'complete') {
        await html.window.onLoad.first;
      }
      // Add router element if not present
      if (html.document.getElementsByTagName('router').whereType<html.Element>().isEmpty) {
        html.document.body?.append(html.Element.tag('router'));
      }
      Router(onRoute);
    });

FutureOr<void> onRoute(Route route, void Function(Object? content) emit) {
  emit('''
  <div id="current-route" class="responsive center-align padding">
    <p>Route: "${route.path}"</p>
    <p>Key: "${route.key}"</p>
    <p>Segments: [${route.segments.map((e) => '"$e"').join(', ')}]</p>
    <p>Params: ${route.params.entries.map((e) => e.value.isEmpty ? e.key : '${e.key}: "${e.value}"').join(', ')}</p>
  </div>
  ''');
}
