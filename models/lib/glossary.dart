import 'dart:io' show File;
import 'utils.dart' show slug;

class GlossaryItem {
  final String name;
  final String? desc;

  const GlossaryItem(this.name, { this.desc });

  String get id => slug(name);
}

class BookGlossary {
  final String filename;
  final Map<String, GlossaryItem> items;

  const BookGlossary(this.filename, this.items);

  factory BookGlossary.fromItems(String file, Iterable<GlossaryItem> list) {
    final map = { for (final i in list) i.id : i };
    return BookGlossary(file, map);
  }

  File get file => File(filename);

  GlossaryItem? operator [](String id) => items[id];

  void add(GlossaryItem item) => items[item.id] = item;

  void addByName(String name, String desc) => add(GlossaryItem(name, desc: desc));

}
