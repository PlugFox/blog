import 'package:backend/src/common/medium/medium.dart';
import 'package:shared/shared.dart' as shared;
import 'package:test/test.dart';

void main() => group('Medium', () {
      const username = 'plugfox';
      final medium = Medium();

      test('Fetch articles', () async {
        final articles = await medium.fetchArticlesRSS(username);
        final shared.Article(:excerpt, :content) = articles.first;
        expect(articles, isNotEmpty);
      });
    });
