import 'package:dartbook/cli/context.dart';
import 'package:dartbook/cli/generator.dart';
import 'package:dartbook/cli/theme_manager.dart';
import 'package:dartbook_theme_default/dartbook_theme_default.dart' as t;
import "package:path/path.dart" as p;
import 'package:html/parser.dart' as html;
import 'package:test/test.dart';

void main() {
  final multilingual = BookContext.assemble(
    root: 'test/_data_multilingual',
  );

  late final String pkgRoot;

  setUp(() async {
    pkgRoot = await t.fsLocation();
  });

  test('page generation & relative path', () {
    final book = multilingual.books['en']!;

    final gen = Generator(
      book: book,
      directoryIndex: true,
    );
    final assetDir = pkgRoot;
    final theme = ThemeManager.build(
      assetDir: assetDir,
      layoutType: 'website',
      lang: 'en',
    );

    book.pages.forEach((filename, page) {
      final raw = gen.generatePage(theme, page);
      final doc = html.parse(raw);
      final links = doc
          .querySelectorAll('head > link')
          .where((e) => e.attributes['rel'] == 'stylesheet');
      final dir = p.dirname(p.join(book.langPath, filename));
      final target = p.relative('dartbook', from: dir);
      expect(links.every((e) {
        return e.attributes['href']?.startsWith(target) ?? false;
      }), true);
    });
  });
}
