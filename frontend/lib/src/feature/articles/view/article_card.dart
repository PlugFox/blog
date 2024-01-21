import 'dart:html' as html;

import 'package:frontend/src/common/view/component.dart';
import 'package:shared/shared.dart';

final class ArticleCard extends Component {
  ArticleCard(this.article) : super(key: article.id);

  final Article article;

  @override
  void build(html.DivElement context) {
    context.className = 'article-card';
    var titleElement = html.HeadingElement.h2()
      ..className = 'article-title'
      ..text = article.title;
    var authorElement = html.ParagraphElement()
      ..className = 'article-author'
      ..text = article.author;
    var dateElement = html.ParagraphElement()
      ..className = 'article-date'
      ..text = DateTime.fromMillisecondsSinceEpoch(article.createdAt * 1000).toString();
    var tagsElement = html.DivElement()..className = 'article-tags';
    var excerptElement = html.ParagraphElement()
      ..className = 'article-excerpt'
      ..innerHtml = article.excerpt;

    for (final tag in article.tags) {
      var tagSpan = html.SpanElement()
        ..className = 'tag'
        ..text = tag;
      tagsElement.children.add(tagSpan);
    }

    context.children.addAll([
      titleElement,
      authorElement,
      dateElement,
      tagsElement,
      excerptElement,
    ]);
  }
}
