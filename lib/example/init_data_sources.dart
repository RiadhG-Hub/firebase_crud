import 'package:firebase_crud/mixin/crud_repos.dart';
import 'package:logger/logger.dart';

class InitDataSources with CrudRepository {
  @override
  String collection = 'buyer';
  @override
  bool forTesting = true;

  @override
  FirestoreService get firestoreService => FirestoreServiceImpl();

  @override
  LoggerService? get loggerService => throw LoggerServiceImpl(Logger(), true);
}
