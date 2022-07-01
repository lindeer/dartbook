
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

  void log(String msg) {

  }
}
