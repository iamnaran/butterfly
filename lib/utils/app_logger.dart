import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class AppLogger {
  static final Logger _logger = Logger('AppLogger');

   static void configureLogging() {
    // Only configure logging if in debug mode
    if (kDebugMode) {
      Logger.root.level = Level.ALL;  
      Logger.root.onRecord.listen((record) {
        // ignore: avoid_print
        print('${record.level.name}: ${record.time}: ${record.message}');
      });
    } else {
      Logger.root.level = Level.OFF;
    }
  }

  // Log info messages
  static void showInfo(String message) {
    _logger.info(message);
  }

  // Log warning messages
  static void showLog(String message) {
    _logger.warning(message);
  }

  // Log error messages
  static void showError(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }

}