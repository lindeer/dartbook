
import 'package:collection/collection.dart' show IterableExtension;
import 'package:dartbook/html/html.dart' show Article;

import 'utils.dart' show PathUtils;

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

  String? get anchor {
    final pos = ref?.indexOf('#');
    return pos == null || pos < 0 ? null : ref?.substring(pos);
  }

  String? get url => isExternal ? ref : null;

  SummaryArticle? byLevel(String level) {
    final levels = level.split('.');
    SummaryArticle? result = this;
    for (final l in levels) {
      final p = int.parse(l) - 1;
      result = result?.articles?.toList(growable: false)[p];
    }
    return result;
  }

  /// directly retrieve children if skipRoot is true
  SummaryArticle? filter(bool Function(SummaryArticle e) test, {bool skipRoot = false}) {
    if (!skipRoot && test(this)) {
      return this;
    }
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

  /// encodeSummaryArticle.js
  static Map<String, dynamic> _toJson(SummaryArticle article) {
    final r = article.ref;
    final path = article.path;
    final anchor = article.anchor;
    final depth = article.depth;
    final url = article.url;
    final items = article.articles;
    return {
      'level': article.level,
      'title': article.title,
      'depth': depth,
      if (r != null)
        'ref': r,
      if (path != null)
        'path': path,
      if (anchor != null)
        'anchor': anchor,
      if (url != null)
        'url': url,
      if (items != null)
        'articles': items.map(_toJson).toList(growable: false),
    };
  }

  Map<String, dynamic> get json => _toJson(this);
}
