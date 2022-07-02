
import 'dart:io' show File;

import 'package:dartbook_models/glossary.dart';
import 'package:dartbook_models/language.dart';
import 'package:dartbook_models/readme.dart';
import 'package:dartbook_models/summary.dart';

abstract class ContentParser {

  LanguageManager langs(File file);

  BookReadme readme(File file);

  BookSummary summary(File file);

  BookGlossary glossary(File file);
}
