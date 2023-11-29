import 'dart:io' show Process, IOSink, exit, stdout;

import 'package:dartbook/cli/logger.dart';
import 'package:diff_match_patch/diff_match_patch.dart';

void main(List<String> args) {
  diffMain(args);
}

/// we would have to add all git diff options if implementing Command class
void diffMain(List<String> args) {
  final logger = Logger(true);
  String text;
  try {
    final result = Process.runSync('git', ['diff', ...args]);
    text = result.stdout as String;
    if (result.exitCode != 0) {
      logger.e("exit(${result.exitCode}");
      exit(result.exitCode);
    }
  } on Exception catch (e) {
    logger.e("Error: $e");
    exit(-1);
  }
  if (text.isNotEmpty) {
    _parseDiffText(stdout, text);
  } else {
    logger.i("'git diff ${args.join(' ')}' return empty!");
  }
}

void _parseDiffText(IOSink sink, String text) {
  final origin = StringBuffer();
  final changed = StringBuffer();

  void apply() {
    if (origin.isNotEmpty || changed.isNotEmpty) {
      _patchDiff(sink, origin.toString(), changed.toString());
      origin.clear();
      changed.clear();
    }
  }
  for (final line in text.split('\n')) {
    if (line.startsWith('---') || line.startsWith('+++')) {
      sink.writeln(line);
    } else if (line.startsWith('-')) {
      origin.writeln(' ${line.substring(1)}');
    } else if (line.startsWith('+')) {
      changed.writeln(' ${line.substring(1)}');
    } else if (line.trim().isEmpty) {
      origin.writeln(line);
      changed.writeln(line);
    } else {
      apply();
    }
  }
  apply();
}

void _patchDiff(IOSink sink, String deleted, String inserted) {
  final diffs = DiffMatchPatch().diff(deleted, inserted);
  for (final d in diffs) {
    if (d.operation == DIFF_DELETE) {
      sink.write('\x1B[31m${d.text}\x1B[0m');
    } else if (d.operation == DIFF_INSERT) {
      sink.write('\x1B[32m${d.text}\x1B[0m');
    } else {
      sink.write(d.text);
    }
  }
}
