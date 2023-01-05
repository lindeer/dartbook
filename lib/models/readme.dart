library dartbook;

import 'package:dartbook/html/readme.dart';

/// readme model in book context
class BookReadme {
  final String filename;
  final String title;
  final String? desc;

  const BookReadme({required this.filename, required this.title, this.desc});

  factory BookReadme.create(String file, Readme readme) =>
      BookReadme(filename: file, title: readme.title, desc: readme.desc);
}
