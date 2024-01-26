import 'dart:async';
import 'dart:html' as html;

import 'package:frontend/frontend.dart';
import 'package:frontend/src/common/view/page.dart';
import 'package:frontend/src/feature/articles/view/article_card.dart';

final class ArticlesPage implements Page {
  ArticlesPage();

  @override
  String get title => 'Articles';

  @override
  void create() {
    if (!$articlesController.state.isProcessing && $articlesController.state.data.isEmpty) {
      $articlesController.fetch();
    }
    $articlesController.addListener(_onArticlesStateChange);
  }

  @override
  Object? build() async {
    const articles = '''
    <h1 class="center-align">Articles</h1>
    <h3 class="center-align">Compact</h3>
    <h5 class="center-align">The beer is ready!</h5>
    <br />
    <div class="divider"></div>
    <br />
    <div id="articles" class="center-align"></div>
    ''';
    final htmlValidator = html.NodeValidatorBuilder.common()
      ..allowElement('a', attributes: ['href'])
      ..allowElement('button')
      ..allowElement('main');
    return html.document.createElement('main')
      /* ..className = 'responsive' */
      ..setInnerHtml(articles, validator: htmlValidator) // ignore: unsafe_html
      ..querySelector('#articles')?.append(_articlesToHtml());
  }

  @override
  Future<void> dispose() async {
    $articlesController.removeListener(_onArticlesStateChange);
  }

  void _onArticlesStateChange() => html.document.body?.querySelector('#articles')
    ?..children.clear()
    ..append(_articlesToHtml());

  html.Node _articlesToHtml() {
    final fragment = html.DocumentFragment(); // html.document.createElement('div'); // html.Element.div();
    for (final article in $articlesController.state.data) {
      fragment.append(ArticleCard.build(article));
    }
    return fragment;
  }
}
