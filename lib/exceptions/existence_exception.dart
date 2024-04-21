class ExistenceException implements Exception {
  final String exceptionValue;
  ExistenceException({required this.exceptionValue});

  String get exception => exceptionValue;
}
