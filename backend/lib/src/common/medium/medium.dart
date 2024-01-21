import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared/shared.dart' as shared;
import 'package:xml/xml.dart' as xml;

/// {@template medium}
/// Medium service.
/// {@endtemplate}
final class Medium {
  /// {@macro medium}
  Medium({
    required http.Client client,
  }) : _client = client;

  final http.Client _client;

  /// Fetch and parse https://medium.com/feed/@username
  Future<List<shared.Article>> fetchArticlesRSS(String username) async {
    final response = await _client.get(Uri.parse('https://medium.com/feed/@$username'));
    if (response.statusCode != 200) throw Exception('Failed to fetch articles');
    final xmlString = response.body;
    final document = xml.XmlDocument.parse(xmlString);
    final items = document.findAllElements('item');
    final dateFormat = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');
    Iterable<String> extractAll(xml.XmlElement node, List<String> names, {bool recursive = false}) => names
        .expand<xml.XmlElement>(recursive ? node.findAllElements : node.findElements)
        .map<String>((e) => e.innerText)
        .where((e) => e.isNotEmpty);
    String? extractFirst(xml.XmlElement node, List<String> names, {bool recursive = false}) =>
        extractAll(node, names, recursive: recursive).firstOrNull;
    int parseDate(String? date) =>
        switch (date?.trim()) {
          String date when date.endsWith('Z') => DateTime.tryParse(date)?.toUtc().millisecondsSinceEpoch ?? 0,
          String date when date.contains('+') => DateTime.tryParse(date)?.toUtc().millisecondsSinceEpoch ?? 0,
          String date when date.contains('-') => DateTime.tryParse(date)?.toUtc().millisecondsSinceEpoch ?? 0,
          String date when date.contains('GMT') => dateFormat.tryParse(date, true)?.toUtc().millisecondsSinceEpoch ?? 0,
          _ => 0,
        } ~/
        1000;
    return items
        .map<shared.Article?>((node) {
          final content = extractFirst(node, ['content:encoded', 'content']) ?? '';
          var excerpt = content.isNotEmpty ? dom.Document.html('<html><body>$content</body></html>').body?.text : null;
          excerpt ??= '';
          if (excerpt.length > 140) excerpt = '${excerpt.substring(0, 140 - 3)}...';
          final link = extractFirst(node, ['link', 'url', 'dc:link', 'og:url', 'al:url']) ?? '';
          final guid = extractFirst(node, ['guid', 'dc:guid', 'identifier'])?.split('/').lastOrNull ??
              link.split('/').lastOrNull?.split('?').firstOrNull?.split('-').lastOrNull;
          if (guid == null || guid.isEmpty) {
            assert(false, 'Failed to parse guid');
            return null;
          }
          return shared.Article(
            title: extractFirst(node, ['title', 'dc:title']) ?? '',
            link: link,
            id: guid,
            author: extractFirst(node,
                    ['dc:creator', 'creator', 'author', 'dc:author', 'atom:author', 'dc:contributor', 'contributor']) ??
                username,
            createdAt: extractAll(node, ['atom:created', 'created', 'pubDate'])
                .map<int>(parseDate)
                .fold<int>(0, (a, b) => a > b ? a : b),
            updatedAt: extractAll(node, ['atom:updated', 'updated', 'pubDate'])
                .map<int>(parseDate)
                .fold<int>(0, (a, b) => a > b ? a : b),
            tags: extractAll(node, ['category', 'tag']).toList(growable: false),
            excerpt: excerpt,
            content: content,
            meta: null,
          );
        })
        .whereType<shared.Article>()
        .toList(growable: false);
  }
}
