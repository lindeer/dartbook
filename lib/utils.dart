import 'package:path/path.dart' as p;

String slug(String content, [String separator = '-']) {
  return Uri.encodeComponent(content.replaceAll(' ', separator)).toLowerCase();
}

class PathUtils {
  static bool isExternal(String uri) {
    try {
      final scheme = _schema(uri);
      return scheme.isNotEmpty && scheme != 'data';
    } catch (e) {
      return false;
    }
  }

  static bool isDataUri(String uri) => _schema(uri) == 'data';

  static bool isRelative(String uri) => !isExternal(uri);

  static String _schema(String uri) => Uri.parse(uri).scheme;

  static String normalize(String path) => p.normalize(path).replaceAll('\\', '/');

  static String flatten(String path) {
    final uri = normalize(path);
    if (uri.startsWith('/')) {
      return p.normalize(uri.substring(1));
    } else {
      return uri;
    }
  }

  static bool areIdentical(String p1, String p2) => normalize(p1) == normalize(p2);
}
