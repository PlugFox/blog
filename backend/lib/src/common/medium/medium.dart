import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared/shared.dart' as shared;
import 'package:xml/xml.dart' as xml;

final class Medium {
  Medium({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Fetch and parse https://medium.com/feed/@username
  Future<List<shared.Article>> fetchArticlesRSS(String username) async {
    final response = await _client.get(Uri.parse('https://medium.com/feed/@$username'));
    if (response.statusCode != 200) throw Exception('Failed to fetch articles');
    final xmlString = response.body;
    final document = xml.XmlDocument.parse(xmlString);
    final items = document.findAllElements('item');
    final dateFormat = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');
    final excerptRegExp = RegExp(r'<p>(?<text>.+)<\/p>');
    Iterable<String> extractAll(List<String> names, {bool recursive = false}) => names
        .expand<xml.XmlElement>(recursive ? document.findAllElements : document.findElements)
        .map<String>((e) => e.innerText)
        .where((e) => e.isNotEmpty);
    String? extractFirst(List<String> names, {bool recursive = false}) =>
        extractAll(names, recursive: recursive).firstOrNull;
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
      final content = extractFirst(['content:encoded', 'content']) ?? '';
      var excerpt = content.isNotEmpty
          ? excerptRegExp.allMatches(content).map<String?>((e) => e.namedGroup('text')).whereType<String>().join(' ')
          : '';
      excerpt = excerpt.replaceAll(RegExp('<[^>]*>'), '');
      if (excerpt.length > 140) excerpt = '${excerpt.substring(0, 140 - 3)}...';
      final link = extractFirst(['link', 'url', 'dc:link']) ?? '';
      return shared.Article(
        id: null,
        title: extractFirst(['title', 'dc:title']) ?? '',
        link: link,
        guid: extractFirst(['guid', 'dc:guid'])?.split('/').lastOrNull ??
            link.split('/').lastOrNull?.split('?').firstOrNull?.split('-').lastOrNull ??
            '',
        author: extractFirst(
                ['dc:creator', 'creator', 'author', 'dc:author', 'atom:author', 'dc:contributor', 'contributor']) ??
            username,
        createdAt: extractAll(['atom:created', 'created', 'pubDate'])
            .map<int>(parseDate)
            .fold<int>(0, (a, b) => a > b ? a : b),
        updatedAt: extractAll(['atom:updated', 'updated', 'pubDate'])
            .map<int>(parseDate)
            .fold<int>(0, (a, b) => a > b ? a : b),
        tags: extractAll(['category', 'tag']).toList(growable: false),
        excerpt: excerpt,
        content: content,
        meta: null,
      );
    }).toList(growable: false);
  }
}
