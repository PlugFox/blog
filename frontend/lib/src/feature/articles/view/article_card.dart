// ignore_for_file: unsafe_html

import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;

import 'package:frontend/src/common/router/router.dart';
import 'package:shared/shared.dart';

abstract final class ArticleCard {
  ArticleCard();

  static html.Element build(Article article) {
    final card = html.Element.tag('article')..className = 'article-card card no-padding no-select elevation';
    final tags = article.tags
        .map((tag) =>
            '<a class="article-tag article-tag-${tag.toLowerCase().replaceAll(' ', '-')}" title="$tag">$tag</a>')
        .join();
    final content = '''
    <div class="card-layout grid no-space">
      <div class="m3 l3 m l">
        <div class="article-thumbnail responsive">
          <img draggable="false" src="images/dash.png"/>
        </div>
      </div>
      <div class="s12 m9 l9">
        <div class="padding">
          <h5 class="article-title">${article.title}</h5>
          <div class="divider small-margin"></div>
          <nav class="article-meta">
            <span class="article-meta-item article-meta-date">
              <time datetime="2023-08-15">
                  Aug 15, 2023
              </time>
            </span>
            <span class="article-meta-item article-meta-read-time">1 MIN READ</span>
            <span class="article-meta-item article-meta-tags">
              $tags
            </span>
          </nav>
          <div class="divider small-margin"></div>
          <p class="article-excerpt">${article.excerpt}</p>
        </div>
      </div>
    </div>
    ''';
    final inkWell = html.Element.tag('ink-well')
      ..setInnerHtml(content,
          validator: html.NodeValidatorBuilder.common()
            ..allowElement('img', attributes: ['src'])
            ..allowElement('a', attributes: ['href', 'p', 'title']));
    inkWell.addEventListener('click', (event) {
      Timer(const Duration(milliseconds: 250),
          () => Router.setRoute('articles/${article.id}', 'Article | ${article.title}'));
      // ... do something ...
      if (event is! html.MouseEvent) return;
      final rect = inkWell.getBoundingClientRect();
      final ripple = html.Element.span()..className = 'ink';
      inkWell.append(ripple);
      ripple.style.width = ripple.style.height = '${math.max(rect.width, rect.height)}px';
      ripple.style.left = '${event.client.x - rect.left - ripple.offsetWidth ~/ 2}px';
      ripple.style.top = '${event.client.y - rect.top - ripple.offsetHeight ~/ 2}px';
      Timer(const Duration(milliseconds: 600), ripple.remove);
    });
    return card..append(inkWell);
  }
}
