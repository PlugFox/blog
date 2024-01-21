import 'dart:async';
import 'dart:html' as html;

import 'package:frontend/src/common/view/component.dart';
import 'package:frontend/src/feature/articles/controller/articles_controller.dart';
import 'package:frontend/src/feature/articles/data/articles_repository.dart';
import 'package:frontend/src/feature/articles/view/article_card.dart';
import 'package:http/browser_client.dart';
import 'package:meta/meta.dart';
import 'package:shared/shared.dart';

final class ArticlesComponent extends Component {
  ArticlesComponent();

  late final ArticlesController _controller;
  List<Article> _articles = <Article>[];

  @override
  void initState() {
    super.initState();
    _controller = ArticlesController(
      repository: ArticlesRepositoryImpl(
        client: BrowserClient(),
        baseUrl: 'http://localhost:8080',
      ),
    )
      ..addListener(_rebuild)
      ..fetch();
    _rebuild();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_rebuild);
  }

  @override
  html.Element build() => html.DivElement()..id = 'articles';

  @protected
  FutureOr<void> _rebuild() async {
    final articles = _controller.state.data;
    if (identical(_articles, articles)) return; // No changes, no need to rebuild
    _articles = articles;
    final stopwatch = Stopwatch()..start();
    try {
      // Get the container of the list
      final container = html.document.getElementById('articles');
      if (container is! html.DivElement) {
        assert(false, 'The element with id "articles" is not a <div> element');
        return;
      }

      // Index existing elements by id
      final existingElements = <String, html.Element>{for (final item in container.children) item.id: item};

      // Remove elements that are no longer in the list
      existingElements.keys
          .where((id) => !articles.any((article) => article.id == id))
          .toList(growable: false)
          .forEach((id) {
        existingElements[id]?.remove();
        existingElements.remove(id);
      });

      // Add new elements
      final newElements = html.DocumentFragment();
      for (final article in articles) {
        if (stopwatch.elapsedMilliseconds > 8) await Future<void>.delayed(Duration.zero);
        if (!existingElements.containsKey(article.id)) {
          var newElement = ArticleCard(article).build();
          newElements.append(newElement);
          existingElements[article.id] = newElement;
        }
      }
      container.append(newElements);
    } finally {
      stopwatch.stop();
    }
  }
}
