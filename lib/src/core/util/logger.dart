import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

final logger = Logger('ROOT');

@immutable
class LoggerUtil {
  static void init() {
    hierarchicalLoggingEnabled = true;
    logger.level = Level.ALL;
    logger.onRecord.listen((record) {
      debugPrint('[${record.loggerName}][${record.level.name}]: ${record.message}');

      if (record.error != null) debugPrint('[Error]: ${record.error}');

      if (record.stackTrace != null) debugPrint('[StackTrace]: ${record.stackTrace}');
    });
  }
}
