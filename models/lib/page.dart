
import 'dart:io' show File;

class Page {
  final String filename;
  final Map<String, String>? attributes;
  final String? content;
  final String dir;

  const Page({
    required this.filename,
    this.attributes,
    this.content,
    this.dir = "ltr",
  });

  File get file => File(filename);
}
