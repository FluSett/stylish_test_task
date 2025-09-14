// ignore_for_file: avoid_print

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

final logger = Logger('ROOT');

@immutable
class LoggerUtil {
  static void init() {
    hierarchicalLoggingEnabled = true;
    logger.level = Level.ALL;
    logger.onRecord.listen((record) {
      print('[${record.loggerName}][${record.level.name}]: ${record.message}');

      if (record.error != null) print('[Error]: ${record.error}');

      if (record.stackTrace != null) print('[StackTrace]: ${record.stackTrace}');
    });
  }
}
