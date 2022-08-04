
import 'dart:async' show FutureOr;
import 'dart:io' show Process, IOSink, exit, stdout;

import 'package:args/command_runner.dart' show Command;
import 'package:dartbook/logger.dart';
import 'package:diff_match_patch/diff_match_patch.dart';

class DiffCommand extends Command<int> {

  @override
  final String name = 'diff';

  @override
  final String description = 'Same usage with git diff but based on character';

  @override
  FutureOr<int> run() {
    final result = argResults;
    _diffMain(result?.rest ?? []);
    return 0;
  }
}

void _diffMain(List<String> args) {
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
  _parseDiffText(stdout, text);
}

void _parseDiffText(IOSink sink, String text) {
  final origin = StringBuffer();
  final changed = StringBuffer();
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
      if (origin.isNotEmpty || changed.isNotEmpty) {
        _patchDiff(sink, origin.toString(), changed.toString());
        origin.clear();
        changed.clear();
      }
      sink.writeln(line);
    }
  }
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
