import 'dart:async';
import 'dart:html' as html;

import 'package:frontend/frontend.dart';
import 'package:frontend/src/common/view/page.dart';

final class ArticlesPage implements Page {
  ArticlesPage();

  @override
  String get name => 'articles';

  @override
  void create() {
    if (!$articlesController.state.isProcessing && $articlesController.state.data.isEmpty) {
      $articlesController.fetch();
    }
    $articlesController.addListener(_onArticlesStateChange);
  }

  @override
  Object? build() async => '<h1>Articles</h1>\n<div class="articles-list">${_articlesToHtml()}</div>';

  @override
  Future<void> dispose() async {
    $articlesController.removeListener(_onArticlesStateChange);
  }

  void _onArticlesStateChange() => html.querySelector('.articles-list')?.innerHtml = _articlesToHtml();

  String _articlesToHtml() =>
      $articlesController.state.data.map((e) => '<p>Article{"id": "${e.id}", "title": "${e.title}"}</p>').join('\n');
}
