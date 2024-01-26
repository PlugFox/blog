// Callback for route change
import 'dart:async';

import 'package:frontend/src/common/router/router.dart';

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

/* Future<String?> getPage(String page) =>
    html.HttpRequest.getString('pages/$page.html').then((value) => value.trim(), onError: (error) => null); */
