import 'dart:io' show Directory, File, Link;
import 'package:path/path.dart' as p;

const opOK = 0;
const opNone = 1;
const opNotExists = 2;

void writeToFile(String file, String result) {
  final out = File(file);
  if (!out.parent.existsSync()) {
    out.createSync(recursive: true);
  }
  out.writeAsStringSync(result);
}

bool _doNothing(String from, String to) {
  if (p.canonicalize(from) == p.canonicalize(to)) {
    return true;
  }
  if (p.isWithin(from, to)) {
    throw ArgumentError('Cannot copy from $from to $to');
  }
  return false;
}

int copyPathSync(String from, String to) {
  if (_doNothing(from, to)) {
    return opNone;
  }
  final dir = Directory(from);
  if (!dir.existsSync()) {
    return opNotExists;
  }
  Directory(to).createSync(recursive: true);
  for (final file in dir.listSync(recursive: true)) {
    final copyTo = p.join(to, p.relative(file.path, from: from));
    if (file is Directory) {
      Directory(copyTo).createSync(recursive: true);
    } else if (file is File) {
      File(file.path).copySync(copyTo);
    } else if (file is Link) {
      Link(copyTo).createSync(file.targetSync(), recursive: true);
    }
  }
  return opOK;
}
