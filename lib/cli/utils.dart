import 'dart:isolate' show Isolate;

/// get the file system location of the given path in package
Future<String> resolvePackageLocation(String path) async {
  final uri = Uri.parse('package:dartbook/$path');
  final pkgUri = await Isolate.resolvePackageUri(uri);
  return pkgUri?.toFilePath() ?? '';
}
