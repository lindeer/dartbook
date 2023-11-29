
import 'package:collection/collection.dart' show IterableExtension;
import 'package:dartbook/html/html.dart' show Article, Part;

import 'article.dart';
import 'part.dart';
import 'readme.dart';
import 'utils.dart' show PathUtils;

class BookSummary {
  final String filename;
  final List<SummaryPart> parts;

  const BookSummary(this.filename, this.parts);

  factory BookSummary.create(String file, Iterable<Part> parts, [BookReadme? readme]) {
    final items = parts.mapIndexed((i, e) {
      /// if tile page is not readme file
      if (i == 0 && readme != null && readme.filename != e.articles?.first.ref) {
        final list = e.articles;
        e = (title: e.title, articles: [
          Article(title: readme.title, ref: readme.filename),
          if (list != null)
            ...list,
        ]);
      }
      return SummaryPart.create(e, '${i + 1}');
    });
    return BookSummary(file, items.toList(growable: false));
  }

  SummaryPart operator[](int pos) => parts[pos];

  Map<String, dynamic> get json => {
    'summary': {
      'parts': parts.map((e) => e.json),
    }
  };

  String parentLevel(String level) {
    final levels = level.split('.');
    final sub = levels.sublist(0, levels.length - 1);
    return sub.join('.');
  }

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

  static void _retrieve(Iterable<SummaryArticle> articles, void Function(SummaryArticle article) it) {
    for (final a in articles) {
      it(a);
      final list = a.articles;
      if (list != null) {
        _retrieve(list, it);
      }
    }
  }

  void walk(void Function(SummaryArticle article) it) {
    for (final part in parts) {
      final list = part.articles;
      if (list != null) {
        _retrieve(list, it);
      }
    }
  }

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

  SummaryArticle? nextArticle(SummaryArticle article) {
    final level = article.level;
    bool wasPrev = false;
    return findArticle((a) {
      if (wasPrev && a.ref != null) return true;
      wasPrev = wasPrev || (a.level == level);
      return false;
    });
  }

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
