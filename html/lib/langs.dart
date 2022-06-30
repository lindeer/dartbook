library dartbook.html;

import 'summary.dart';

class Langs {

  final Iterable<Article> articles;

  const Langs._(this.articles);

  static Langs from(String html) {
    final parts = Summary.from(html).parts;
    return Langs._(parts.isEmpty ? const []
        : (parts.first.articles ?? const []));
  }
}
