import 'dart:async';
import 'dart:html' as html;

import 'package:frontend/frontend.dart';
import 'package:frontend/src/common/view/page.dart';

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
    final articles = '''
    <h1>Articles</h1>
    <h3 class="center-align">Compact</h3>
    <h5 class="center-align">The beer is ready!</h5>
    <br />
    <div class="divider" />
    <br />
    <div id="articles">${_articlesToHtml()}</div>
    ''';
    final htmlValidator = html.NodeValidatorBuilder.common()
      ..allowElement('a')
      ..allowElement('button')
      ..allowElement('main');
    return html.Element.tag('main')
      ..className = 'responsive'
      ..setInnerHtml(articles, validator: htmlValidator); // ignore: unsafe_html
  }

  @override
  Future<void> dispose() async {
    $articlesController.removeListener(_onArticlesStateChange);
  }

  void _onArticlesStateChange() =>
      html.querySelector('#articles')?.setInnerHtml(_articlesToHtml()); // ignore: unsafe_html

  String _articlesToHtml() =>
      $articlesController.state.data.map((e) => '<p>Article{"id": "${e.id}", "title": "${e.title}"}</p>').join('\n');
}
