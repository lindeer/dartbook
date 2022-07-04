
import 'book.dart';
import 'page.dart';
import 'plugin.dart';
import 'utils.dart';

class Output {
  final Book book;
  /// Name of the generator being used
  final String generator;
  /// Map of plugins to use (String -> Plugin)
  final Map<String, Plugin> plugins;
  /// Map pages to generation (String -> Page)
  final Map<String, BookPage> pages;
  /// assets list
  final Iterable<String> assets;
  /// Options of generation
  final Map<String, String> options;
  /// Internal state for the generation
  final Map<String, String> state;

  Output({
    required this.book,
    required this.generator,
    required this.plugins,
    required this.pages,
    required this.assets,
    required this.options,
    required this.state,
  });

  BookPage? page(String file) => pages[PathUtils.normalize(file)];

  String? get root => options['root'];
}
