import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/exceptions/existence_exception.dart';
import 'package:firebase_crud/extensions/collection.dart';
import 'package:firebase_crud/mixin/log.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

mixin CrudRepos {
  dynamic get object;
  String? get id => object.id;
  String get collection => '';
  bool get forTesting => false;

  CollectionReference<Object?> _instructionCollection() => collection.collection(forTesting: forTesting);
  //short cast of doc
  Future<DocumentSnapshot<Object?>> get docById => _instructionCollection().doc(id).get();

  Future<void> add() async {
    final now = DateTime.now();
    "⌛ adding of ${object.runtimeType} with id equal to ${object.id} in progress".log();
    try {
      DocumentSnapshot result = await docById;

      ///find out whether exist
      if (result.exists) {
        await result.reference.update(object.toJson());
        '✅ ${object.runtimeType} with id: ${object.id} was added successfully '.log();
      } else {
        //add data

        await result.reference.set(object.toJson(), SetOptions(merge: true));

        '✅ ${object.runtimeType} with id: ${object.id} was added successfully '.log();
      }
    } on ExistenceException {
      'no command executed'.log();
      '🟡 ${object.runtimeType} with id equal to ${object.id} is already exist'.log();
      rethrow;
    } on FirebaseException catch (e) {
      "🔴 ${e.plugin.toUpperCase()} Message: ${e.message} code: ${e.code}".log();
      rethrow;
    } catch (e) {
      '🔴 error in: repos/crud_repos.dart with: $e error runtimeType: ${e.runtimeType}, when trying to add ${object.runtimeType}'
          .log();
      throw e.toString();
    } finally {
      if (forTesting) {
        debugPrint('adding command is finished after ${DateTime.now().difference(now).inMilliseconds} MS');
      }
      'adding command is finished after ${DateTime.now().difference(now).inMilliseconds} MS'.log();
    }
  }

  @useResult
  Future<Map<String, dynamic>> fetch({String? documentId}) async {
    final now = DateTime.now();

    "⌛ fetching in progress".log();
    try {
      DocumentSnapshot result = id == null ? await docById : await _instructionCollection().doc(documentId).get();

      if (result.exists) {
        //return data
        return result.data() as Map<String, dynamic>;
      } else {
        throw ExistenceException(exceptionValue: '${object.runtimeType} not exist yet');
      }
    } on ExistenceException catch (e) {
      print(e);
      '🟡 ${object.runtimeType} with id: $id is not exist'.log();
      rethrow;
    } on FirebaseException catch (e) {
      "🔴 ${e.plugin.toUpperCase()} Message: ${e.message} code: ${e.code}".log();
      throw e.message!;
    } catch (e) {
      '🔴 error in: lib/model/repos/crud_repos.dart with: $e type${e.runtimeType} when trying to fetch ${object.runtimeType} with id:$id'
          .log();
      throw e.toString();
    } finally {
      'fetching command is finished after ${DateTime.now().difference(now).inMilliseconds} MS'.log();
    }
  }

  Future<void> delete() async {
    final now = DateTime.now();
    "⌛ deleting of ${object.runtimeType} with id equal to ${object.id} in progress".log();
    try {
      DocumentSnapshot result = await docById;

      ///check instructor if [isExist]
      if (result.exists) {
        //delete data
        await result.reference.delete();
        '✅ ${object.runtimeType} with ${object.id} was deleted successfully '.log();
      } else {
        throw ExistenceException(exceptionValue: '${object.runtimeType} not exist');
      }
    } on ExistenceException catch (e) {
      '🟡 ${object.runtimeType} with id: ${object.id} is not exist'.log();
      throw Exception(e.exception);
    } on FirebaseException catch (e) {
      "🔴 ${e.plugin.toUpperCase()} Message: ${e.message} code: ${e.code}".log();
      throw Exception(e.message!);
    } catch (e) {
      '🔴 error in: lib/model/repos/crud_repos.dart with: $e type${e.runtimeType} when trying to delete ${object.runtimeType}'
          .log();
      throw Exception(e.toString());
    } finally {
      'deleting command is finished after ${DateTime.now().difference(now).inMilliseconds} MS'.log();
    }
  }

  Future<void> updateData() async {
    final now = DateTime.now();
    "⌛ updating of ${object.runtimeType} with id equal to ${object.id} in progress".log();
    try {
      DocumentSnapshot result = await docById;

      if (result.exists) {
        //update data
        await result.reference.update(object.toMap);
        '✅ ${object.runtimeType} with ${object.id} was updated successfully'.log();
      } else {
        throw Exception('${object.runtimeType} not exist');
      }
    } on ExistenceException catch (e) {
      '🟡 ${object.runtimeType} with id: ${object.id} is not exist'.log();
      throw Exception(e.exception);
    } on FirebaseException catch (e) {
      "🔴  ${e.plugin.toUpperCase()} Message: ${e.message} code: ${e.code}".log();
      throw Exception(e.message);
    } catch (e) {
      '🔴 error in:crud_repos.dart with: $e type${e.runtimeType} when trying to update ${object.runtimeType}'.log();
      throw Exception(e);
    } finally {
      'updating command is finished after ${DateTime.now().difference(now).inMilliseconds} MS'.log();
    }
  }

  @useResult
  Future<bool> isExist() async {
    try {
      DocumentSnapshot result = await docById;

      final exist = result.exists;
      '✅ ${object.runtimeType} with id: $id is $exist '.log();
      return exist;
    } on FirebaseException catch (e) {
      "🔴 ${e.plugin.toUpperCase()} Message: ${e.message} code: ${e.code}".log();
      throw e.message!;
    } catch (e) {
      '🔴 error in: crud_repos.dart with: $e type${e.runtimeType} when trying to check existence of ${object.runtimeType}'
          .log();
      rethrow;
    }
  }

  @useResult
  Future<List<Map<String, dynamic>>> fetchAll() async {
    final now = DateTime.now();
    "⌛ fetching in progress".log();
    try {
      final collectionValue = await _instructionCollection().get();
      final List<QueryDocumentSnapshot<Object?>> docs = collectionValue.docs;
      docs.first.data()?.log();
      final List<Map<String, dynamic>> result = docs.map((e) => e.data() as Map<String, dynamic>).toList();
      return result;
    } on ExistenceException catch (e) {
      '🟡 ${object.runtimeType} with id: $id is not exist'.log();
      throw Exception(e.exception);
    } on FirebaseException catch (e) {
      "🔴 ${e.plugin.toUpperCase()} Message: ${e.message} code: ${e.code}".log();
      throw e.message!;
    } catch (e) {
      '🔴 error in: crud_repos.dart with: $e type${e.runtimeType} when trying to fetch ${object.runtimeType} with id:$id'
          .log();
      throw e.toString();
    } finally {
      'fetching command is finished after ${DateTime.now().difference(now).inMilliseconds} MS'.log();
    }
  }
}
