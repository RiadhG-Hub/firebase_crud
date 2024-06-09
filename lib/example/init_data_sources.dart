import 'package:firebase_crud/mixin/crud_repos.dart';

class InitDataSources with CrudRepos {
  @override
  String collection = 'buyer';
  @override
  bool forTesting = true;
}
