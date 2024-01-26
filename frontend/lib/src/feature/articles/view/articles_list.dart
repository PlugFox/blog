/* final class ArticlesComponent extends Component {
  ArticlesComponent() : super(key: 'articles');

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
      ..addListener(rebuild)
      ..fetch();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(rebuild);
  }

  @override
  @protected
  Future<void> build(html.Element context) async {
    final articles = _controller.state.data;
    if (identical(_articles, articles)) return; // No changes, no need to rebuild
    _articles = articles;
    final stopwatch = Stopwatch()..start();
    try {
      // Get the container of the list

      final existingElements = <String, html.Element>{for (final item in context.children) item.id: item};
      // Remove elements that are no longer in the list
      existingElements.keys
          .where((id) => !articles.any((article) => article.id == id))
          .toList(growable: false)
          .forEach((id) {
        existingElements[id]?.remove();
        existingElements.remove(id);
      });

      // Add new elements
      final fragment = html.DocumentFragment();
      for (final article in articles) {
        if (stopwatch.elapsedMilliseconds > 8) await Future<void>.delayed(Duration.zero);
        if (!existingElements.containsKey(article.id)) {
          final card = ArticleCard(article);
          fragment.append(card.element);
          existingElements[article.id] = card.element;
        }
      }
      context.append(fragment);
    } finally {
      stopwatch.stop();
    }
  }
} */
