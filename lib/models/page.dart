class BookPage {
  final String filename;
  final Map<String, String>? attributes;
  String? content;
  final String dir;

  BookPage({
    required this.filename,
    this.attributes,
    this.content,
    this.dir = "ltr",
  });
}
