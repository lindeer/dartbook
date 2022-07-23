
import 'package:dartbook/context.dart';
import 'package:test/test.dart';

void main() {
  final root1 = 'test/_data_multilingual';
  final multilingual = BookContext.assemble(
    root: root1,
  );

  final root2 = 'test/_data_normal';
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
}
