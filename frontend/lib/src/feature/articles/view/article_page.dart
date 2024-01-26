import 'dart:html' as html;

import 'package:collection/collection.dart';
import 'package:frontend/frontend.dart';
import 'package:frontend/src/common/view/page.dart';
import 'package:frontend/src/feature/articles/view/article_card.dart';
import 'package:shared/shared.dart';

final class ArticlePage implements Page {
  ArticlePage({required this.id})
      : _article = $articlesController.state.data.firstWhereOrNull((article) => article.id == id);

  final String id;

  final Article? _article;

  @override
  String get title => 'Article | ${_article?.title ?? 'Unknown'}';

  @override
  void create() {}

  @override
  Object? build() async {
    final content = '''
    <header class="post-header container medium">
        <h3 class="post-title center-align">${_article?.title ?? 'Unknown'}</h3>
    </header>
    <div class="post-content"></div>
    ''';
    final htmlValidator = html.NodeValidatorBuilder.common()
      ..allowElement('a', attributes: ['href'])
      ..allowElement('button')
      ..allowElement('header');
    return html.document.createElement('article')
      ..className = 'post no-image single'
      ..setInnerHtml(content, validator: htmlValidator) // ignore: unsafe_html
      ..querySelector('.post-content')?.append(_articlesContent());
  }

  @override
  void dispose() {}

  html.Node _articlesContent() {
    final fragment = html.DocumentFragment(); // html.document.createElement('div'); // html.Element.div();
    if (_article != null) fragment.append(ArticleCard.build(_article));
    return fragment;
  }
}
