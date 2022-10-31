import 'dart:io' show stdout;

class Logger {
  final bool verbose;

  Logger(this.verbose);

  void i(String msg) {
    stdout.writeln(msg);
  }

  void d(String msg) {
    if (verbose) {
      print('\x1B[36m$msg\x1B[0m');
    }
  }

  void e(String msg) {
    print('\x1B[31m$msg\x1B[0m');
  }

  void w(String msg) {
    print('\x1B[33m$msg\x1B[0m');
  }
}
