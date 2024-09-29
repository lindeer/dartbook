import 'package:dartbook/html/html.dart' show Article, Part;

import 'article.dart';
import 'part.dart';
import 'readme.dart';
import 'utils.dart' show PathUtils;

/// Composed by several parts with a given path.
class BookSummary {
  final String filename;
  final List<SummaryPart> parts;

  const BookSummary(this.filename, this.parts);

  /// Create a summary object by a [file] path, several [parts], and maybe a
  /// [readme].
  factory BookSummary.create(String file, Iterable<Part> parts,
      [BookReadme? readme]) {
    final items = parts.indexed.map((r) {
      /// if tile page is not readme file
      final (i, e) = r;
      var p = e;
      final ref = e.articles?.first.ref;
      if (i == 0 && readme != null && readme.filename != ref) {
        final list = e.articles;
        p = (
          title: e.title,
          articles: [
            Article(title: readme.title, ref: readme.filename),
            if (list != null) ...list,
          ],
        );
      }
      return SummaryPart.create(p, '${i + 1}');
    });
    return BookSummary(file, items.toList(growable: false));
  }

  SummaryPart operator [](int pos) => parts[pos];

  Map<String, dynamic> get json => {
        'summary': {
          'parts': parts.map((e) => e.json),
        },
      };

  String parentLevel(String level) {
    final levels = level.split('.');
    final sub = levels.sublist(0, levels.length - 1);
    return sub.join('.');
  }

  /// Find a article object by given [level].
  SummaryArticle? byLevel(String level) {
    try {
      return _locate(level);
    } catch (e) {
      return null;
    }
  }

  SummaryArticle? _locate(String level) {
    final index = level.indexOf('.');
    final firstLevel = level.substring(0, index);
    final pos = int.parse(firstLevel) - 1;
    final part = parts[pos];
    final root = SummaryArticle(
      level: firstLevel,
      title: part.title,
      articles: part.articles,
    );

    return root.byLevel(level.substring(index + 1));
  }

  /// Find a article object by given [path].
  SummaryArticle? byPath(String path) {
    SummaryArticle? result;
    for (final part in parts) {
      final root = SummaryArticle(
        level: '',
        title: '',
        articles: part.articles,
      );
      result = root.filter((e) {
        final articlePath = e.path;
        return articlePath != null && PathUtils.areIdentical(articlePath, path);
      }, skipRoot: true);
      if (result != null) {
        break;
      }
    }
    return result;
  }

  static void _retrieve(Iterable<SummaryArticle> articles,
      void Function(SummaryArticle article) it) {
    for (final a in articles) {
      it(a);
      final list = a.articles;
      if (list != null) {
        _retrieve(list, it);
      }
    }
  }

  /// Retrieve an article tree by the observer pattern.
  void walk(void Function(SummaryArticle article) it) {
    for (final part in parts) {
      final list = part.articles;
      if (list != null) {
        _retrieve(list, it);
      }
    }
  }

  /// Find an article object with a given callback [test].
  SummaryArticle? findArticle(bool Function(SummaryArticle a) test) {
    SummaryArticle? result;
    for (final part in parts) {
      final root = SummaryArticle(
        level: '',
        title: '',
        articles: part.articles,
      );
      result = root.filter(test, skipRoot: true);
      if (result != null) {
        break;
      }
    }
    return result;
  }

  /// Find the sibling article.
  SummaryArticle? nextArticle(SummaryArticle article) {
    final level = article.level;
    bool wasPrev = false;
    return findArticle((a) {
      if (wasPrev && a.ref != null) return true;
      wasPrev = wasPrev || (a.level == level);
      return false;
    });
  }

  /// Find the previous sibling article.
  SummaryArticle? prevArticle(SummaryArticle article) {
    final level = article.level;
    SummaryArticle? prev;
    findArticle((a) {
      if (a.level == level) {
        return true;
      }
      if (a.ref != null) {
        prev = a;
      }
      return false;
    });
    return prev;
  }
}
