// Callback for route change
import 'dart:async';

import 'package:frontend/src/common/router/router.dart';
import 'package:frontend/src/common/view/page.dart';
import 'package:frontend/src/feature/articles/view/articles_page.dart';
import 'package:frontend/src/feature/contacts/view/contacts_page.dart';

/// Current page name
String get $currentPageName => _currentPage?.name ?? '';
Page? _currentPage;

FutureOr<void> onRoute(Route route, void Function(Object? content) emit) async {
  runZonedGuarded<void>(() => _currentPage?.dispose(), (error, stackTrace) {/* */});
  _currentPage = null;
  final segment = route.segments.firstOrNull;
  final id = route.segments.elementAtOrNull(1);
  switch (segment) {
    case 'article' || 'post' when id != null:
      emit('<p>Article #$id</p>');
    case 'contact' || 'contacts':
      _currentPage = ContactsPage();
    case 'about' || 'cv' || 'me' || 'resume':
      emit('<p>About</p>');
    case null || '' || 'articles' || 'medium' || 'posts' || 'home' || '404':
    default:
      _currentPage = ArticlesPage();
  }
  if (_currentPage == null) {
    emit('<p>404</p>');
    return;
  }
  await _currentPage?.create();
  final content = await _currentPage?.build();
  emit(content);

  /* emit('''
  <div id="current-route" class="responsive center-align padding">
    <p>Route: "${route.path}"</p>
    <p>Key: "${route.key}"</p>
    <p>Segments: [${route.segments.map((e) => '"$e"').join(', ')}]</p>
    <p>Params: ${route.params.entries.map((e) => e.value.isEmpty ? e.key : '${e.key}: "${e.value}"').join(', ')}</p>
  </div>
  '''); */
}
