import 'package:firebase_crud/mixin/crud_repos.dart';

import 'model/model_example.dart';

class InitDataSources with CrudRepos {
  @override
  late ModelExample object;
  @override
  String? id;
  @override
  String get collection => 'buyer';
  @override
  bool forTesting = true;
}
