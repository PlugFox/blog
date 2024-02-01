import 'dart:html' as html;

import 'package:collection/collection.dart';
import 'package:frontend/frontend.dart';
import 'package:frontend/src/common/view/page.dart';
import 'package:frontend/src/feature/articles/controller/article_controller.dart';
import 'package:shared/shared.dart';

final class ArticlePage implements Page {
  ArticlePage({required this.id})
      : _controller = ArticleController(
          initialState: ArticleState.idle(
              data: $articlesController.state.data.firstWhereOrNull((article) => article.id == id) ?? Article()
                ..id = id),
          repository: $articlesRepository,
        );

  final String id;

  Article get _article => _controller.state.data;

  final ArticleController _controller;

  @override
  String get title => 'Article | ${_article.hasTitle() ? _article.title : 'Unknown'}';

  @override
  void create() {
    _controller
      ..fetch()
      ..addListener(_onControllerChange);
  }

  @override
  Object? build() async {
    /*
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
    */
    const content = '''
    <div class="post-content"></div>
    ''';
    final htmlValidator = html.NodeValidatorBuilder.common()
      ..allowElement('a', attributes: ['href'])
      ..allowElement('button')
      ..allowElement('header');

    return html.document.createElement('article')
      ..className = 'post no-image single'
      ..setInnerHtml(content, validator: htmlValidator) // ignore: unsafe_html
      ..querySelector('.post-content')?.append(html.ParagraphElement()..text = 'Loading...');
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  void _onControllerChange() {
    final state = _controller.state;
    if (!state.isIdling) return;
    if (!state.data.hasContent()) return;
    final content = state.data.content;
    html.document.querySelector('.post-content')
      ?..children.clear()
      ..appendHtml(content);
  }
}
