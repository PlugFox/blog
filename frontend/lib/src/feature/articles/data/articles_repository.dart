// ignore_for_file: one_member_abstracts

import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';

abstract interface class IArticlesRepository {
  /// Fetches articles from the server.
  Future<List<Article>> fetch({int? limit, int? offset, int? from, int? to});

  /// Fetches an article by id from the server.
  Future<Article> getById(String id);
}

final class ArticlesRepositoryImpl implements IArticlesRepository {
  ArticlesRepositoryImpl({required http.Client client, required String baseUrl})
      : _client = client,
        _baseUrl = baseUrl;

  final String _baseUrl;
  final http.Client _client;

  @override
  Future<List<Article>> fetch({int? limit, int? offset, int? from, int? to}) async {
    final uri = Uri.parse('$_baseUrl/articles').replace(queryParameters: <String, String>{
      if (limit != null) 'limit': limit.toString(),
      if (offset != null) 'offset': offset.toString(),
      if (from != null) 'from': from.toString(),
      if (to != null) 'to': to.toString(),
      'format': 'proto',
    });
    final result = await _client.get(uri);
    if (result.statusCode != 200) throw Exception('Failed to fetch articles: ${result.statusCode}');
    return Articles.fromBuffer(result.bodyBytes).articles;
  }

  @override
  Future<Article> getById(String id) async {
    final uri = Uri.parse('$_baseUrl/articles/$id').replace(queryParameters: <String, String>{
      'format': 'proto',
    });
    final result = await _client.get(uri);
    if (result.statusCode != 200) throw Exception('Failed to fetch article: ${result.statusCode}');
    return Article.fromBuffer(result.bodyBytes);
  }
}
