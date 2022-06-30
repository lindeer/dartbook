
import 'dart:io' show File;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:dartbook_html/summary.dart' show Article;
import 'package:dartbook/utils.dart' show PathUtils;

class SummaryArticle {
  final String level;
  final String title;
  final String? ref;
  final Iterable<SummaryArticle>? articles;

  const SummaryArticle({
    required this.level,
    required this.title,
    this.ref,
    this.articles,
  });

  factory SummaryArticle.create(Article article, String level) {
    final articles = article.articles?.mapIndexed((i, e) {
      if (e is SummaryArticle) {
        return e as SummaryArticle;
      } else {
        return SummaryArticle.create(e, "$level.${i + 1}");
      }
    });
    return SummaryArticle(
      level: level,
      title: article.title,
      ref: article.ref,
      articles: articles,
    );
  }

  int get depth => level.split('.').length - 1;

  bool get isExternal => ref == null ? false : PathUtils.isExternal(ref!);

  String get childLevel => '$level.${(articles?.length ?? 0) + 1}';

  String? get path {
    if (isExternal) return null;
    final r = ref;
    if (r == null) return null;
    int pos = r.indexOf('#');
    final pathname = pos < 0 ? r : r.substring(0, pos);
    return PathUtils.flatten(pathname);
  }

  bool isFile(File file) => file.path == path;

  SummaryArticle? byLevel(String level) {
    final levels = level.split('.');
    SummaryArticle? result = this;
    for (final l in levels) {
      final p = int.parse(l) - 1;
      result = result?.articles?.toList(growable: false)[p];
    }
    return result;
  }

  SummaryArticle? filter(bool Function(SummaryArticle e) test) {
    if (test(this)) return this;
    // final result = articles?.reduce((result, e) => (result.filter(test) ?? e));
    // return result != null && test(result) ? result : null;
    for (final a in (articles ?? const <SummaryArticle>[])) {
      final result = a.filter(test);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}
