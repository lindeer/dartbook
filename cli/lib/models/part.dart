
import 'package:collection/collection.dart' show IterableExtension;
import 'package:dartbook_html/summary.dart';

import 'article.dart';

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
        return SummaryArticle.create(e, '$level.${i + 1}');
      }
    });
    return SummaryPart(
        level: level,
        title: part.title,
        articles: articles,
    );
  }

  String get childLevel => '$level.${(articles?.length ?? 0) + 1}';
}
