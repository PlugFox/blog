import 'dart:convert';

import 'package:backend/src/common/database/database.dart' as db;
import 'package:backend/src/common/medium/article_dao.dart';
import 'package:backend/src/common/medium/medium.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared/shared.dart';
import 'package:test/test.dart';

import 'fake_articles.dart';
import 'medium_test.mocks.dart';

/// Check if the medium articles are fetched and stored in the database.
@GenerateNiceMocks([MockSpec<http.Client>()])
void main() => group('Medium', () {
      const username = 'plugfox';
      late final db.Database database;
      late final MockClient client;
      late final Medium medium;
      late final ArticleDAO dao;
      late final List<Article> fakeArticles;

      setUpAll(() async {
        client = MockClient();
        database = db.Database.memory();
        medium = Medium(client: client);
        dao = ArticleDAO(database: database);
        fakeArticles = $fakeArticles;
      });

      tearDownAll(() async {
        client.close();
        await database.close();
      });

      test('fetch_articles', () async {
        // Mock the http client to return the fake articles.
        when(client.get(Uri.parse('https://medium.com/feed/@$username'))).thenAnswer(
          (_) async {
            final bytes = utf8.encode($fakeArticlesRSS);
            return http.Response.bytes(
              bytes,
              200,
              headers: <String, String>{
                'content-type': 'text/xml; charset=UTF-8',
                'content-length': '${bytes.length}',
              },
              persistentConnection: false,
              isRedirect: false,
            );
          },
        );
        final articles = await medium.fetchArticlesRSS(username);
        expect(articles, isNotEmpty);
      });

      test('insert_articles', () async {
        await dao.upsertArticlesIntoDatabase(fakeArticles);
        final articlesFromDatabase = await dao.getArticlesFromDatabase();
        expect(articlesFromDatabase, isNotEmpty);
        expect(articlesFromDatabase.length, equals(fakeArticles.length));
        final articleFromDatabase = await dao.getArticleFromDatabase(fakeArticles.first.id);
        expect(articleFromDatabase, isNotNull);
        expect(articleFromDatabase, isA<Article>());
        articleFromDatabase!;
        expect(articleFromDatabase.id, equals(fakeArticles.first.id));
        expect(articleFromDatabase.content, isNotEmpty);
        final tags = await database.select(database.articleTagTbl).get();
        expect(tags, isNotEmpty);
        final prefixes = await database.select(database.articlePrefixTbl).get();
        expect(prefixes, isNotEmpty);
      });

      test('search_by_tags', () async {
        await dao.upsertArticlesIntoDatabase(fakeArticles);
        final articles = await dao.searchInDatabase('dart,  flutter');
        expect(articles, isNotEmpty);
        expect(articles.any((a) => a.tags.contains('flutter')), isTrue);
      });

      test('search_by_words', () async {
        await dao.upsertArticlesIntoDatabase(fakeArticles);
        final articles = await dao.searchInDatabase('Flut,  archite; isola');
        expect(articles, isNotEmpty);
      });

      test('search_by_tags_and_words', () async {
        await dao.upsertArticlesIntoDatabase(fakeArticles);
        final articles = await dao.searchInDatabase('dart/flutter Flut,  archite; isola');
        expect(articles, isNotEmpty);
      });
    });
