import 'package:collection/collection.dart' show IterableExtension;
import 'package:dartbook/html/html.dart' show Part;

import 'article.dart';

/// A part object including several [SummaryArticle],
/// while with [title] and [level]. We could know the depth by [level].
/// A part is just an article tree.
class SummaryPart {
  final String level;
  final String title;
  final Iterable<SummaryArticle>? articles;

  const SummaryPart({
    required this.level,
    required this.title,
    this.articles,
  });

  factory SummaryPart.create(Part part, String level) {
    final articles = part.articles?.mapIndexed((i, e) {
      if (e is SummaryArticle) {
        return e as SummaryArticle;
      } else {
        final prefix = level.isEmpty ? '' : '$level.';
        return SummaryArticle.create(e, '$prefix${i + 1}');
      }
    });
    return SummaryPart(
      level: level,
      title: part.title,
      articles: articles,
    );
  }

  String get childLevel => '$level.${(articles?.length ?? 0) + 1}';

  Map<String, dynamic> get json {
    final items = articles;
    return {
      'title': title,
      'level': level,
      'articles': items?.map((e) => e.json) ?? const <Map<String, dynamic>>[],
    };
  }
}
