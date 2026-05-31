/// Exception thrown when a document existence check fails or encounters an error.
class ExistenceException implements Exception {
  /// The error message describing the exception.
  final String exceptionValue;

  /// Creates an [ExistenceException] with the given error message.
  ExistenceException({required this.exceptionValue});

  /// Retrieves the exception message.
  String get exception => exceptionValue;

  @override
  String toString() => 'ExistenceException: $exceptionValue';
}
