import 'package:logger/logger.dart';

/// Logging Service
abstract class LoggerService {
  void log(String message, {Level level});
  void logError(String message, String errorDetails, {Level level});
  void logCompletionTime(DateTime startTime, String operation);
}

class LoggerServiceImpl implements LoggerService {
  final Logger _logger;
  final bool _enableLogging;

  LoggerServiceImpl(this._logger, this._enableLogging);

  @override
  void log(String message, {Level level = Level.info}) {
    if (_enableLogging) {
      _logger.log(level, message);
    }
  }

  @override
  void logError(String message, String errorDetails, {Level level = Level.error}) {
    if (_enableLogging) {
      _logger.log(level, "$message. Details: $errorDetails");
    }
  }

  @override
  void logCompletionTime(DateTime startTime, String operation) {
    final duration = DateTime.now().difference(startTime).inMilliseconds;
    log('$operation completed in $duration ms');
  }
}