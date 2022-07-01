
import 'dart:io' show File;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:dartbook_html/summary.dart';
import 'utils.dart' show PathUtils;

import 'article.dart';
import 'part.dart';

class BookSummary {
  final String filename;
  final List<SummaryPart> parts;

  const BookSummary(this.filename, this.parts);

  factory BookSummary.create(String file, Iterable<Part> parts) {
    final items = parts.mapIndexed((i, e) {
      return SummaryPart.create(e, '${i + 1}');
    });
    return BookSummary(file, items.toList(growable: false));
  }

  File get file => File(filename);

  SummaryPart operator[](int pos) => parts[pos];

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
    final root = SummaryArticle(
      level: firstLevel,
      title: '',
      articles: parts[pos].articles,
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
      });
      if (result != null) {
        break;
      }
    }
    return result;
  }
}
