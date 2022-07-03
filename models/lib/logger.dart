
enum Level {
  disable,
  debug,
  info,
  warn,
  error,
}

const _colors = {
  Level.debug: '\x1B[34m',
  Level.info: '\x1B[36m',
  Level.warn: '\x1B[33m',
  Level.error: '\x1B[31m',
};

class Logger {
  final bool verbose;

  Logger(String? level): verbose = level == 'debug';

  void i(String msg) {
    print(msg);
  }

  void d(String msg) {
    if (verbose) {
      print(msg);
    }
  }

  void e(String msg) {
  }

  void w(String msg) {
  }
}
