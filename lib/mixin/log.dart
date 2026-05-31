import 'dart:developer' as devtools show log;

/// Extension on [Object] to add convenient logging functionality.
///
/// This extension provides a quick way to log the string representation of any object
/// to the Dart developer console without importing the dev tools directly.
///
/// Example:
/// ```dart
/// 'Hello World'.log();  // Logs: Hello World
/// 42.log();             // Logs: 42
/// [1, 2, 3].log();      // Logs: [1, 2, 3]
/// ```
extension Log on Object {
  /// Logs the string representation of this object to the developer console.
  ///
  /// Uses [dart:developer]'s log function to write output that can be viewed
  /// in the Flutter debug console or IDE debugger.
  void log() => devtools.log(toString());
}
