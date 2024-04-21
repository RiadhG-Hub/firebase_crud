import 'package:firebase_crud/example/model/user_buyer.dart';
import 'package:firebase_crud/mixin/crud_repos.dart';

class InitDataSources with CrudRepos {
  @override
  late UserBuyer object;
  @override
  String? id;
  @override
  String get collection => 'buyer';
}
