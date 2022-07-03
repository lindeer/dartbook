
import 'dart:io' show File;

class BookPage {
  final String filename;
  final Map<String, String>? attributes;
  final String? content;
  final String dir;

  const BookPage({
    required this.filename,
    this.attributes,
    this.content,
    this.dir = "ltr",
  });

  File get file => File(filename);
}
