import 'dart:async' show StreamTransformerBase;
import 'dart:convert' show LineSplitter, utf8;
import 'dart:io' show Process, exit, stdout, stderr;

import 'package:dartbook/cli/logger.dart';
import 'package:diff_match_patch/diff_match_patch.dart';

void main(List<String> args) {
  diffMain(args);
}

/// we would have to add all git diff options if implementing Command class
void diffMain(List<String> args) async {
  final logger = Logger(true);
  try {
    final proc = await Process.start('git', ['diff', ...args]);
    stderr.addStream(proc.stderr);
    stdout.addStream(proc.stdout
        .transform(utf8.decoder)
        .transform(_DiffTransformer())
        .transform(utf8.encoder)
    );
    final result = await proc.exitCode;
    if (result != 0) {
      logger.e("exit($result");
      exit(result);
    }
  } on Exception catch (e) {
    logger.e("Error: $e");
    exit(-1);
  }
}

class _DiffTransformer extends StreamTransformerBase<String, String> {
  final origin = StringBuffer();
  final changed = StringBuffer();
  final patcher = DiffMatchPatch();

  @override
  Stream<String> bind(Stream<String> stream) async* {
    final lines = stream.transform(LineSplitter());

    await for (final line in lines) {
      if (line.startsWith('---') || line.startsWith('+++')) {
        yield '$line\n';
      } else if (line.startsWith('-')) {
        origin.writeln(' ${line.substring(1)}');
      } else if (line.startsWith('+')) {
        changed.writeln(' ${line.substring(1)}');
      } else if (line.trim().isEmpty) {
        origin.writeln(line);
        changed.writeln(line);
      } else {
        yield* _apply();
      }
    }
    yield* _apply();
  }

  Stream<String> _apply() async* {
    if (origin.isNotEmpty || changed.isNotEmpty) {
      final diffs = patcher.diff(origin.toString(), changed.toString());
      for (final d in diffs) {
        if (d.operation == DIFF_DELETE) {
          yield '\x1B[31m${d.text}\x1B[0m';
        } else if (d.operation == DIFF_INSERT) {
          yield '\x1B[32m${d.text}\x1B[0m';
        } else {
          yield d.text;
        }
      }
      origin.clear();
      changed.clear();
    }
  }
}
