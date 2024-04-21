class ExistenceException implements Exception {
  final String exceptionValue;
  ExistenceException({required this.exceptionValue});

  String get exception => exceptionValue;
}

class AuthFailed implements Exception {
  final String exceptionValue;
  AuthFailed({required this.exceptionValue}) : super();

  String get exception => exceptionValue;
}
