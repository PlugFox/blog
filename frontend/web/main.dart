import 'dart:async';
import 'dart:developer';
import 'dart:html' as html;

import 'package:frontend/src/common/router/router.dart';

void main() => runZonedGuarded<Future<void>>(
      () async {
        void runApp() {
          //html.document.body?.append(ArticlesComponent().element);
          if (html.document.getElementsByTagName('router').whereType<html.Element>().isEmpty) {
            html.document.body?.append(html.Element.tag('router'));
          }
          Router(onRoute);
        }

        if (html.document.readyState?.trim().toLowerCase() == 'complete') {
          runApp();
        } else {
          html.window.onLoad.listen((_) => runApp());
        }
      },
      (error, stackTrace) => log(
        'Top level exception',
        error: error,
        stackTrace: stackTrace,
        level: 1000,
        name: 'main',
      ),
    );

FutureOr<void> onRoute(Route route, void Function(Object? content) emit) {
  emit('''
  <div id="current-route" class="responsive center-align padding">
    <p>Route: ${route.path}</p>
    <p>Key: ${route.key}</p>
    <p>Name: ${route.name}</p>
    <p>Segments: ${route.segments.join(', ')}</p>
    <p>Params: ${route.params.entries.map((e) => '${e.key}: ${e.value}').join(', ')}</p>
  </div>
  ''');
}
