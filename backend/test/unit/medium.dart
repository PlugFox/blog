import 'package:backend/src/common/database/database.dart' as db;
import 'package:backend/src/common/medium/medium.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

/// Check if the medium articles are fetched and stored in the database.
void main() => group('Medium', () {
      const username = 'plugfox';
      late final db.Database database;
      late final http.Client client;
      late final Medium medium;

      setUpAll(() async {
        client = http.Client();
        database = db.Database.memory();
        medium = Medium(
          client: client,
          database: database,
        );
      });

      tearDownAll(() async {
        client.close();
        await database.close();
      });

      test('Fetch articles and store in database', () async {
        final articles = await medium.fetchArticlesRSS(username);
        expect(articles, isNotEmpty);
        final ids = <String>{...articles.map((e) => e.id)};
        await medium.upsertArticlesIntoDatabase(articles);
        final articlesFromDatabase = await medium.getArticlesFromDatabase();
        expect(articlesFromDatabase, isNotEmpty);
        expect(articlesFromDatabase.length, equals(articles.length));
        expect(articlesFromDatabase.map((e) => e.id).toSet(), equals(ids));
      });
    });
