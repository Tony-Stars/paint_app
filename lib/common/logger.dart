class Logger {
  static void error(Object? object, {StackTrace? stackTrace}) {
    stackTrace ??= StackTrace.current;
    // ignore: avoid_print
    print('$object $stackTrace');
  }
}
