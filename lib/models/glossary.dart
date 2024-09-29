import 'utils.dart' show slug;

/// A glossary item for a book.
class GlossaryItem {
  final String name;
  final String? desc;

  const GlossaryItem(
    this.name, {
    this.desc,
  });

  String get id => slug(name);
}

/// A glossary object for a book, including [filename] and item list.
class BookGlossary {
  final String filename;
  final Map<String, GlossaryItem> items;

  const BookGlossary(this.filename, this.items);

  static const empty = BookGlossary('', {});

  /// Create a BookGlossary with given glossary objects.
  factory BookGlossary.fromItems(
    String file,
    Iterable<({String name, String? desc})> items,
  ) {
    final list = items.map((e) => GlossaryItem(e.name, desc: e.desc));
    final map = {for (final i in list) i.id: i};
    return BookGlossary(file, map);
  }

  GlossaryItem? operator [](String id) => items[id];

  void add(GlossaryItem item) => items[item.id] = item;

  void addByName(String name, String desc) =>
      add(GlossaryItem(name, desc: desc));
}
