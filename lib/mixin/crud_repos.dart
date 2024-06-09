import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/extensions/collection.dart';
import 'package:firebase_crud/mixin/log.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

mixin CrudRepos {
  String get collection => '';
  bool get forTesting => false;

  CollectionReference<Object?> _instructionCollection() => collection.collection(forTesting: forTesting);
  //short cast of doc
  Future<DocumentSnapshot<Object?>> docById({required docId}) => _instructionCollection().doc(docId).get();

  Future<void> add({required Map<String, dynamic> data}) async {
    final now = DateTime.now();
    "⌛ adding of $data  in progress".log();
    try {
      if (data.containsKey('id')) {
        assert(data['id'] is String, 'id should be a String');

        ///find out whether exist

        //add data

        await _instructionCollection().doc(data['id']).set(data, SetOptions(merge: true));

        '✅ $data  was added successfully '.log();
      } else {
        await _instructionCollection().doc().set(data, SetOptions(merge: true));
      }
    } catch (e) {
      '🔴 error in: repos/crud_repos.dart with: $e error runtimeType: ${e.runtimeType}, when trying to add $data'.log();
      throw e.toString();
    } finally {
      if (forTesting) {
        debugPrint('adding command is finished after ${DateTime.now().difference(now).inMilliseconds} MS');
      }
      'adding command is finished after ${DateTime.now().difference(now).inMilliseconds} MS'.log();
    }
  }

  @useResult
  Future<Map<String, dynamic>?> fetch({required String documentId}) async {
    final now = DateTime.now();

    "⌛ fetching in progress".log();
    try {
      DocumentSnapshot result = await _instructionCollection().doc(documentId).get();

      if (result.exists) {
        //return data
        return result.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      "🔴 ${e.plugin.toUpperCase()} Message: ${e.message} code: ${e.code}".log();
      throw e.message!;
    } catch (e) {
      '🔴 error in: lib/model/repos/crud_repos.dart with: $e type${e.runtimeType} when trying to fetch document with id $documentId '
          .log();
      throw e.toString();
    } finally {
      'fetching command is finished after ${DateTime.now().difference(now).inMilliseconds} MS'.log();
    }
  }

  Future<void> delete({required documentID}) async {
    final now = DateTime.now();
    "⌛ deleting of document with id equal to $documentID  in progress".log();
    try {
      await _instructionCollection().doc(documentID).delete();

      '✅ document with id equal to:  $documentID  was deleted successfully '.log();
    } on FirebaseException catch (e) {
      "🔴 ${e.plugin.toUpperCase()} Message: ${e.message} code: ${e.code}".log();
      throw Exception(e.message!);
    } catch (e) {
      '🔴 error in: lib/model/repos/crud_repos.dart with: $e type${e.runtimeType} when trying to delete document with id equal to: ${documentID}'
          .log();
      throw Exception(e.toString());
    } finally {
      'deleting command is finished after ${DateTime.now().difference(now).inMilliseconds} MS'.log();
    }
  }

  Future<void> updateData({required Map<String, dynamic> data, String? documentId}) async {
    final now = DateTime.now();
    "⌛ updating of $data  in progress".log();
    final bool dataContainId = data.containsKey('id');
    try {
      if (dataContainId) {
        assert(data['id'] is String, 'id should be a String');

        ///find out whether exist

        //add data

        await _instructionCollection().doc(data['id']).update(
              data,
            );

        '✅ ${data['id']}  was updated successfully'.log();
      } else {
        assert(!dataContainId && dataContainId != null, 'add a id to the document or add a an id to method param ');
        await _instructionCollection().doc(documentId).update(
              data,
            );
      }
    } on FirebaseException catch (e) {
      "🔴  ${e.plugin.toUpperCase()} Message: ${e.message} code: ${e.code}".log();
      throw Exception(e.message);
    } catch (e) {
      '🔴 error in:crud_repos.dart with: $e type${e.runtimeType} when trying to update '.log();
      throw Exception(e);
    } finally {
      'updating command is finished after ${DateTime.now().difference(now).inMilliseconds} MS'.log();
    }
  }

  @useResult
  Future<bool> isExist({required String documentId}) async {
    try {
      DocumentSnapshot result = await docById(docId: documentId);

      final exist = result.exists;
      '✅ the document with id equal to: $documentId is Exist: $result'.log();
      return exist;
    } on FirebaseException catch (e) {
      "🔴 ${e.plugin.toUpperCase()} Message: ${e.message} code: ${e.code}".log();
      throw e.message!;
    } catch (e) {
      '🔴 error in: crud_repos.dart with: $e type${e.runtimeType} when trying to check existence of document with id equal to $documentId'
          .log();
      rethrow;
    }
  }

  @useResult
  Future<List<dynamic>> fetchAll() async {
    final now = DateTime.now();
    "⌛ fetching in progress".log();
    try {
      final collectionValue = await _instructionCollection().get();
      final List<QueryDocumentSnapshot<Object?>> docs = collectionValue.docs;
      docs.first.data()?.log();
      final List<Map<String, dynamic>> result = docs.map((e) => e.data() as Map<String, dynamic>).toList();
      return result;
    } on FirebaseException catch (e) {
      "🔴 ${e.plugin.toUpperCase()} Message: ${e.message} code: ${e.code}".log();
      throw e.message!;
    } catch (e) {
      '🔴 error in: crud_repos.dart with: $e type${e.runtimeType} when trying to fetch  all data  '.log();
      throw e.toString();
    } finally {
      'fetching command is finished after ${DateTime.now().difference(now).inMilliseconds} MS'.log();
    }
  }
}
