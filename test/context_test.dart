
import 'dart:io';

import 'package:dartbook/cli/context.dart';
import 'package:dartbook/cli/logger.dart';
import 'package:dartbook/cli/parser.dart';
import 'package:html/parser.dart' as html;
import 'package:test/test.dart';

void main() {
  final root1 = 'test/_data_multilingual';
  final multilingual = BookContext.assemble(
    root: root1,
  );

  final root2 = 'test/_data_multilingual/en';
  final normal = BookContext.assemble(
    root: root2,
  );

  test('context structure file', () {
    final book = multilingual.books['en']!;
    expect(book.readme.filename, 'README.md');
    expect(book.summary.filename, 'SUMMARY.md');

    expect(book.pages.keys.contains('chapter1/chapter1.md'), true);

    final book2 = normal.books.values.first;
    expect(book2.readme.filename, 'README.md');
    expect(book2.summary.filename, 'SUMMARY.md');
  });

  test('context list asset', () {
    expect(multilingual.listAssets().toSet(), {
      '$root1/unused.txt',
      '$root1/en/images/a.png',
      '$root1/en/assets/css/normal.css',
    });

    expect(multilingual.listAssets(relative: true).toSet(), {
      'unused.txt',
      'en/images/a.png',
      'en/assets/css/normal.css',
    });

    expect(normal.listAssets().toSet(), {
      '$root2/images/a.png',
      '$root2/assets/css/normal.css',
    });
  });

  test('context config', () {
    final topConfig = multilingual.config;
    final book = multilingual['en']!;
    expect(topConfig['title'], null);
    expect(book.config['title'], 'A Great journey to Sicily');
    expect(normal.config['title'], 'A Great journey to Sicily');
  });

  test('context summary', () {
    final book = normal.books.values.first;
    final parts = book.summary.parts;
    expect(parts.length, 3);
    final first = parts.first;
    expect(first.title, '');
    expect(first.articles?.length, 1);

    final second = parts[1];
    expect(second.title, 'Part2');
    expect(second.articles?.length, 1);
    final chapter1 = second.articles?.first;

    final third = parts.last;
    expect(third.title, 'Part3');
    expect(third.articles?.length, 1);
    final chapter2 = book.summary.byLevel('3.1');
    expect(chapter2 != null, true);
    expect(chapter2?.title, 'Chapter2');
    expect(chapter2?.ref, null);

    final section2_1 = chapter2?.articles?.first;
    final prev = book.summary.prevArticle(section2_1!);
    expect(chapter1?.title, prev?.title);
  });

  test('global parser for footnote', () {
    final parser = MarkdownParser(Logger(false));
    final d1 = html.parse(parser.page(File('$root1/en/README.md').readAsStringSync()).content);
    final d2 = html.parse(parser.page(File('$root1/zh/README.md').readAsStringSync()).content);
    final e = d2.querySelector('sup > a');
    expect(e?.text, "1");
  });
}
