import 'package:firebase_crud/mixin/crud_repos.dart';
import 'package:firebase_crud/mixin/firestore_write_service.dart';
import 'package:firebase_crud/mixin/logger_service.dart';
import 'package:logger/logger.dart';

class InitDataSources with FirestoreWriteRepository {
  @override
  // TODO: implement firestoreWriteService
  FirestoreWriteService get firestoreWriteService => FirestoreWriteServiceImpl();

  @override
  // TODO: implement loggerService
  LoggerService? get loggerService => LoggerServiceImpl(Logger(), true);

  @override
  // TODO: implement collection
  String get collection => "collection_name";
}
