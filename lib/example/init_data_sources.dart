import 'package:firebase_crud/mixin/crud_repos.dart';

class InitDataSources with CrudRepository {
  @override
  String collection = 'buyer';
  @override
  bool forTesting = true;
}
