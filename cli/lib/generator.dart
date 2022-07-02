
import 'package:path/path.dart' as p;
import 'package:dartbook_models/book.dart';

class Options {
  /// Root folder for the output
  final String root;
  /// Prefix for generation
  final String? prefix;
  /// Use directory index url instead of "index.html"
  final bool directoryIndex;

  const Options({
    required this.root,
    this.prefix,
    this.directoryIndex = true,
  });

  Options copyWith({String? root, String? prefix, bool? index}) {
    return Options(
      root: root ?? this.root,
      prefix: prefix ?? this.prefix,
      directoryIndex: index ?? directoryIndex,
    );
  }
}

typedef GeneratorFactory = Generator Function(Options opt);

final _factories = <String, GeneratorFactory> {
  'website' : (Options opt) => WebGenerator(opt),
};

abstract class Generator {
  final String name;
  final Options opt;

  const Generator.__(this.name, this.opt);

  factory Generator(String name, Options opt) => _factories[name]!.call(opt);

  factory Generator.from(List<String> args, Map<String, String> options) {
    int len = args.length;
    final root = len > 0 ? args[0] : '.';
    final out = len > 1 ? args[1] : '_book';
    final dir = p.normalize(p.absolute(p.join(root, out)));
    final fmt = options['format'];
    final generator = _factories[fmt]!.call(Options(
      root: dir,
    ));
    return generator;
  }

  // TODO: prepare(BookContext context, Book book)
  void prepare(BookManager manager, String bookKey);

  void init(BookManager manager, String bookKey);

  void finish(BookManager manager, String bookKey);
}

class WebGenerator extends Generator {
  WebGenerator(Options opt) : super.__('website', opt);

  @override
  void prepare(BookManager manager, String bookKey) {
  }

  @override
  void init(BookManager manager, String bookKey) {
  }

  @override
  void finish(BookManager manager, String bookKey) {
  }
}
