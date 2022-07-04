
import 'parser.dart';
import 'package:dartbook_models/logger.dart';

class AppContext {
  final Logger logger;
  final ContentParser parser;

  AppContext(this.logger, this.parser);
}
