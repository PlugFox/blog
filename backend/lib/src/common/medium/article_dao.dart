import 'dart:typed_data' as td;

import 'package:backend/src/common/database/database.dart' as db;
import 'package:html/dom.dart' as dom;
import 'package:shared/shared.dart' as shared;

/// {@template article_dao}
/// Data Access Object for articles.
/// {@endtemplate}
final class ArticleDAO {
  /// {@macro article_dao}
  ArticleDAO({required db.Database database}) : _database = database;

  final db.Database _database;

  /// Upsert articles into the database.
  Future<void> upsertArticlesIntoDatabase(List<shared.Article> articles) => _database.batch((batch) async {
        batch
          // Insert articles
          ..insertAllOnConflictUpdate(
            _database.articleTbl,
            articles
                .where((a) => a.hasId() && a.id.isNotEmpty)
                .map<db.Insertable<db.ArticleTblData>>(
                  (a) => db.ArticleTblCompanion(
                    id: db.Value<String>(a.id),
                    title: db.Value(a.hasTitle() ? a.title : ''),
                    createdAt: db.Value(a.hasCreatedAt() ? a.createdAt : 0),
                    updatedAt: db.Value(a.hasUpdatedAt() ? a.updatedAt : 0),
                    data: db.Value((a.deepCopy()..content = '').writeToBuffer()),
                  ),
                )
                .toList(growable: false),
          )
          // Delete tags
          ..deleteWhere(
            _database.articleTagTbl,
            (tbl) => tbl.articleId.isIn(
              articles.where((a) => a.hasId() && a.id.isNotEmpty).map<String>((a) => a.id).toSet(),
            ),
          )
          // Insert tags
          ..insertAllOnConflictUpdate(
            _database.articleTagTbl,
            articles.where((a) => a.hasId() && a.id.isNotEmpty).expand<db.Insertable<db.ArticleTagTblData>>(
                  (a) => a.tags.map(
                    (t) => db.ArticleTagTblCompanion.insert(
                      articleId: a.id,
                      tag: t,
                    ),
                  ),
                ),
          )
          // Insert content
          ..insertAllOnConflictUpdate(
            _database.articleContentTbl,
            articles
                .where((a) => a.hasId() && a.id.isNotEmpty)
                .map<db.Insertable<db.ArticleContentTblData>>(
                  (a) => db.ArticleContentTblCompanion(
                    articleId: db.Value<String>(a.id),
                    content: db.Value(a.hasContent() ? a.content : ''),
                  ),
                )
                .toList(growable: false),
          );
        // Prepare search table
        final search = <String, Set<String>>{/* String article.id : Set<String> words */};
        for (final article in articles) {
          if (!article.hasId() || article.id.isEmpty) continue;
          final words = <String>{};
          search[article.id] = words;
          final content = article.content;
          if (content.isEmpty) continue;
          final text = dom.Document.html('<html><body>$content</body></html>').body?.text.toLowerCase();
          if (text == null || text.isEmpty) continue;
          words.addAll(text.split(' ').where((w) => w.length > 2));
        }
        batch
          // Delete prefixes
          ..deleteWhere(
            _database.articlePrefixTbl,
            (tbl) => tbl.articleId.isIn(search.keys),
          )
          // Insert prefixes
          ..insertAllOnConflictUpdate(
            _database.articlePrefixTbl,
            search.entries.expand<db.Insertable<db.ArticlePrefixTblData>>(
              (e) => e.value.map(
                (v) => db.ArticlePrefixTblCompanion.insert(
                  articleId: e.key,
                  len: v.length,
                  prefix: v.substring(0, 3),
                  word: v,
                ),
              ),
            ),
          );
      });

  /// Get articles from the database.
  Future<List<shared.Article>> getArticlesFromDatabase({int? from, int? to, int? limit, int? offset}) async {
    final select = _database.select(_database.articleTbl);
    if (from != null) select.where((tbl) => tbl.createdAt.isBiggerOrEqualValue(from));
    if (to != null) select.where((tbl) => tbl.createdAt.isSmallerOrEqualValue(to));
    select
      ..limit(limit ?? 1000, offset: offset ?? 0)
      ..orderBy([(tbl) => db.OrderingTerm.asc(tbl.createdAt)]);
    return await select.get().then((rows) =>
        rows.map<td.Uint8List>((a) => a.data).map<shared.Article>(shared.Article.fromBuffer).toList(growable: false));
  }

  /// Get article from the database.
  Future<shared.Article?> getArticleFromDatabase(String id) async {
    final select = (_database.select(_database.articleTbl)
          ..where((tbl) => tbl.id.equals(id))
          ..limit(1))
        .join([
      db.leftOuterJoin(
        _database.articleContentTbl,
        _database.articleContentTbl.articleId.equalsExp(_database.articleTbl.id),
      )
    ]);

    final row = await select.getSingleOrNull();
    if (row == null) return null;
    return shared.Article.fromBuffer(row.readTable(_database.articleTbl).data)
      ..content = row.readTable(_database.articleContentTbl).content;
  }

  // TODO(plugfox): implement search
  /// Search articles in the database.
  ///
  /// Search performing by tags and words
  Future<List<shared.Article>> searchInDatabase(String search) => Future.value(<shared.Article>[]);
}