import 'package:backend/src/common/database/database.dart' as db;
import 'package:backend/src/common/medium/article_dao.dart';
import 'package:backend/src/common/medium/medium.dart';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';
import 'package:test/test.dart';

import 'fake_articles.dart';

/// Check if the medium articles are fetched and stored in the database.
void main() => group('Medium', () {
      const username = 'plugfox';
      late final db.Database database;
      late final http.Client client;
      late final Medium medium;
      late final ArticleDAO dao;
      late final List<Article> fakeArticles;

      setUpAll(() async {
        client = http.Client();
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

      test('search_by_word', () async {
        await dao.upsertArticlesIntoDatabase(fakeArticles);
        final articles = await dao.searchInDatabase('Flut,  archite; isola');
        expect(articles, isNotEmpty);
      });
    });
