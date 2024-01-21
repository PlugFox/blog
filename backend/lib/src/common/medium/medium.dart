import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared/shared.dart' as shared;
import 'package:xml/xml.dart' as xml;

final class Medium {
  Medium({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<shared.Article>> fetchArticlesRSS(String username) async {
    final response = await _client.get(Uri.parse('https://medium.com/feed/@$username'));
    if (response.statusCode != 200) throw Exception('Failed to fetch articles');
    final xmlString = response.body;
    final document = xml.XmlDocument.parse(xmlString);
    final items = document.findAllElements('item');
    final dateFormat = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');
    final excerptRegExp = RegExp(r'<p>(?<text>.+)<\/p>');
    int parseDate(String? date) =>
        switch (date?.trim()) {
          String date when date.endsWith('Z') => DateTime.tryParse(date)?.toUtc().millisecondsSinceEpoch ?? 0,
          String date when date.contains('+') => DateTime.tryParse(date)?.toUtc().millisecondsSinceEpoch ?? 0,
          String date when date.contains('-') => DateTime.tryParse(date)?.toUtc().millisecondsSinceEpoch ?? 0,
          String date when date.contains('GMT') => dateFormat.tryParse(date, true)?.toUtc().millisecondsSinceEpoch ?? 0,
          _ => 0,
        } ~/
        1000;
    return items.map((node) {
      final content = node.findElements('content:encoded').firstOrNull?.innerText ?? '';
      var excerpt = content.isNotEmpty
          ? excerptRegExp.allMatches(content).map<String?>((e) => e.namedGroup('text')).whereType<String>().join(' ')
          : '';
      excerpt = excerpt.replaceAll(RegExp('<[^>]*>'), '');
      if (excerpt.length > 140) excerpt = '${excerpt.substring(0, 140 - 3)}...';
      return shared.Article(
        id: null,
        title: node.findElements('title').firstOrNull?.innerText ?? '',
        link: node.findElements('link').firstOrNull?.innerText ?? '',
        guid: node.findElements('guid').firstOrNull?.innerText ?? '',
        author: <String>[
              'dc:creator',
              'creator',
              'author',
              'dc:author',
              'atom:author',
              'dc:contributor',
              'contributor',
            ].expand(node.findElements).map((e) => e.innerText).whereType<String>().firstOrNull ??
            username,
        createdAt: <String>['atom:created', 'created', 'pubDate']
            .expand(node.findElements)
            .map((e) => e.innerText)
            .whereType<String>()
            .map(parseDate)
            .fold<int>(0, (a, b) => a > b ? a : b),
        updatedAt: <String>['atom:updated', 'updated', 'pubDate']
            .expand(node.findElements)
            .map((e) => e.innerText)
            .whereType<String>()
            .map(parseDate)
            .fold<int>(0, (a, b) => a > b ? a : b),
        tags: <String>['category', 'tag']
            .expand(node.findElements)
            .map<String?>((e) => e.innerText)
            .whereType<String>()
            .toList(growable: false),
        excerpt: excerpt,
        content: content,
        meta: null,
      );
    }).toList(growable: false);
  }
}
