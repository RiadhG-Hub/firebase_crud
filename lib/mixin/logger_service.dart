import 'package:logger/logger.dart';

/// Logging Service
///
/// This abstract class defines the interface for a logging service.
/// It provides methods for logging messages, logging errors with details,
/// and logging the completion time of operations.
abstract class LoggerService {
  /// Logs a general message.
  ///
  /// [message]: The message to be logged.
  /// [level]: The level of the log (e.g., info, warning, error). Defaults to `Level.info`.
  void log(String message, {Level level});

  /// Logs an error message along with error details.
  ///
  /// [message]: The error message to be logged.
  /// [errorDetails]: Additional details or stack trace related to the error.
  /// [level]: The level of the log (defaults to `Level.error`).
  void logError(String message, String errorDetails, {Level level});

  /// Logs the time taken to complete an operation.
  ///
  /// [startTime]: The starting time of the operation.
  /// [operation]: The name or description of the operation being logged.
  void logCompletionTime(DateTime startTime, String operation);
}

/// Implementation of LoggerService
///
/// This class provides a concrete implementation of the LoggerService interface.
/// It utilizes the `Logger` package to log messages to the console or other outputs.
/// It also includes a toggle to enable or disable logging.
class LoggerServiceImpl implements LoggerService {
  final Logger _logger; // Logger instance for logging messages
  final bool _enableLogging; // Flag to enable/disable logging

  /// Constructor that initializes the logger and enables/disables logging based on [enableLogging].
  LoggerServiceImpl(this._logger, this._enableLogging);

  /// Logs a general message to the logger.
  ///
  /// This method logs a message at the specified log level (defaults to `Level.info`).
  /// If logging is disabled, no logs will be generated.
  ///
  /// [message]: The message to be logged.
  /// [level]: The log level for the message (e.g., info, warning, error). Defaults to `Level.info`.
  @override
  void log(String message, {Level level = Level.info}) {
    if (_enableLogging) {
      _logger.log(
          level, message); // Logs the message using the provided log level
    }
  }

  /// Logs an error message with additional details.
  ///
  /// This method logs an error message at the specified log level (defaults to `Level.error`).
  /// If logging is disabled, no logs will be generated.
  ///
  /// [message]: The error message to be logged.
  /// [errorDetails]: Additional error details (e.g., exception message or stack trace).
  /// [level]: The log level for the error message (defaults to `Level.error`).
  @override
  void logError(String message, String errorDetails,
      {Level level = Level.error}) {
    if (_enableLogging) {
      _logger.log(level,
          "$message. Details: $errorDetails"); // Logs error message with additional details
    }
  }

  /// Logs the time taken to complete an operation.
  ///
  /// This method calculates the time difference between the provided [startTime] and the current time.
  /// It then logs the completion time of the operation in milliseconds.
  ///
  /// [startTime]: The time the operation started.
  /// [operation]: A description of the operation being logged.
  @override
  void logCompletionTime(DateTime startTime, String operation) {
    // Calculate the duration in milliseconds
    final duration = DateTime.now().difference(startTime).inMilliseconds;

    // Log the completion time with the operation name and duration
    log('$operation completed in $duration ms');
  }
}
