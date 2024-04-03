library dartbook;

/// readme model in book context
class BookReadme {
  final String filename;
  final String title;
  final String? desc;

  const BookReadme({required this.filename, required this.title, this.desc});

  factory BookReadme.create(String file, String title, String? desc) =>
      BookReadme(filename: file, title: title, desc: desc);
}
