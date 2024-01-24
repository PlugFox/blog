import 'dart:async';
import 'dart:developer';
import 'dart:html' as html;

import 'package:frontend/src/common/router/router.dart';
import 'package:l/l.dart';

void main() => l.capture(
      () => runZonedGuarded<void>(
        runApp,
        (error, stackTrace) => log(
          'Top level exception',
          error: error,
          stackTrace: stackTrace,
          level: 1000,
          name: 'main',
        ),
      ),
      LogOptions(
        handlePrint: true,
        outputInRelease: false,
        printColors: false,
        overrideOutput: _logPrinter(),
      ),
    );

String? Function(LogMessage) _logPrinter() => (event) => '[${event.level.prefix}] '
    '${event.timestamp.hour.toString().padLeft(2, '0')}:'
    '${event.timestamp.minute.toString().padLeft(2, '0')}:'
    '${event.timestamp.second.toString().padLeft(2, '0')} | '
    '${switch (event.message.toString()) {
      String msg when msg.length > 100 => '${msg.substring(0, 100 - 4)} ...',
      String msg => msg,
    }}';

/// Run app
void runApp() => Future<void>(() async {
      // Wait for DOM to load
      if (html.document.readyState?.trim().toLowerCase() != 'complete') {
        await html.window.onLoad.first;
      }
      // Add router element if not present
      if (html.document.getElementsByTagName('router').whereType<html.Element>().isEmpty) {
        html.document.body?.append(html.Element.tag('router'));
      }
      // Run router
      Router(onRoute);
    });

/* Future<String?> getPage(String page) =>
    html.HttpRequest.getString('pages/$page.html').then((value) => value.trim(), onError: (error) => null); */

// Callback for route change
FutureOr<void> onRoute(Route route, void Function(Object? content) emit) async {
  final page = route.segments.firstOrNull;
  final id = route.segments.elementAtOrNull(1);
  switch (page) {
    case 'article' || 'post' when id != null:
      emit('<p>Article #$id</p>');
    case 'contact' || 'contacts':
      //await getPage('contacts').then(emit);
      emit('<p>Contacts</p>');
    case 'about' || 'cv' || 'me' || 'resume':
      emit('<p>About</p>');
    case null || '' || 'home' || '404':
    default:
      emit('<p>Home</p>');
  }

  /* emit('''
  <div id="current-route" class="responsive center-align padding">
    <p>Route: "${route.path}"</p>
    <p>Key: "${route.key}"</p>
    <p>Segments: [${route.segments.map((e) => '"$e"').join(', ')}]</p>
    <p>Params: ${route.params.entries.map((e) => e.value.isEmpty ? e.key : '${e.key}: "${e.value}"').join(', ')}</p>
  </div>
  '''); */
}
