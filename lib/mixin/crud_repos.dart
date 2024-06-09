import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/extensions/collection.dart';
import 'package:firebase_crud/mixin/log.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

/// A mixin providing CRUD operations for a Firestore collection.
mixin CrudRepos {
  /// The name of the collection in Firestore.
  String get collection => '';

  /// Flag indicating whether the operations are for testing purposes.
  bool get forTesting => false;

  /// Gets the reference to the Firestore collection.
  CollectionReference<Object?> get _collectionRef => collection.collection(forTesting: forTesting);

  /// Fetches a document by its ID.
  ///
  /// Returns a [DocumentSnapshot] of the document with the given [docId].
  Future<DocumentSnapshot<Object?>> docById({required String docId}) => _collectionRef.doc(docId).get();

  /// Adds a new document or updates an existing document in the collection.
  ///
  /// If the [data] contains an 'id', it updates the document with that ID.
  /// Otherwise, it creates a new document.
  Future<void> add({required Map<String, dynamic> data}) async {
    final now = DateTime.now();
    "⌛ Adding $data in progress".log();

    try {
      final docRef = data.containsKey('id') ? _collectionRef.doc(data['id']) : _collectionRef.doc();
      await docRef.set(data, SetOptions(merge: true));
      '✅ ${data.containsKey('id') ? data['id'] : "New document"} was added successfully'.log();
    } on Exception catch (e) {
      _handleError(e, 'add', data);
    } finally {
      _logCompletionTime(now, 'Adding');
    }
  }

  /// Fetches a document by its ID.
  ///
  /// Returns a [Map<String, dynamic>?] representing the document data, or `null` if the document does not exist.
  @useResult
  Future<Map<String, dynamic>?> fetch({required String documentId}) async {
    final now = DateTime.now();
    "⌛ Fetching document with ID $documentId in progress".log();

    try {
      final result = await docById(docId: documentId);
      return result.exists ? result.data() as Map<String, dynamic>? : null;
    } on Exception catch (e) {
      _handleError(e, 'fetch', {'documentId': documentId});
      return null; // This line is never reached because `_handleError` throws.
    } finally {
      _logCompletionTime(now, 'Fetching');
    }
  }

  /// Deletes a document by its ID.
  Future<void> delete({required String documentID}) async {
    final now = DateTime.now();
    "⌛ Deleting document with ID $documentID in progress".log();

    try {
      await _collectionRef.doc(documentID).delete();
      '✅ Document with ID $documentID was deleted successfully'.log();
    } on Exception catch (e) {
      _handleError(e, 'delete', {'documentID': documentID});
    } finally {
      _logCompletionTime(now, 'Deleting');
    }
  }

  /// Updates a document with the provided data.
  ///
  /// If the [data] contains an 'id', it updates the document with that ID.
  /// Otherwise, it updates the document with the provided [documentId].
  Future<void> updateData({required Map<String, dynamic> data, String? documentId}) async {
    final now = DateTime.now();
    "⌛ Updating $data in progress".log();

    try {
      final docRef = data.containsKey('id') ? _collectionRef.doc(data['id']) : _collectionRef.doc(documentId);
      await docRef.update(data);
      '✅ Document ${data['id'] ?? documentId} was updated successfully'.log();
    } on Exception catch (e) {
      _handleError(e, 'update', data);
    } finally {
      _logCompletionTime(now, 'Updating');
    }
  }

  /// Checks if a document exists by its ID.
  ///
  /// Returns `true` if the document exists, otherwise `false`.
  @useResult
  Future<bool> isExist({required String documentId}) async {
    try {
      final result = await docById(docId: documentId);
      final exist = result.exists;
      '✅ Document with ID $documentId exists: $exist'.log();
      return exist;
    } on Exception catch (e) {
      _handleError(e, 'isExist', {'documentId': documentId});
      return false; // This line is never reached because `_handleError` throws.
    }
  }

  /// Fetches all documents in the collection.
  ///
  /// Returns a [List<Map<String, dynamic>>] containing all documents data.
  @useResult
  Future<List<Map<String, dynamic>>> fetchAll() async {
    final now = DateTime.now();
    "⌛ Fetching all documents in progress".log();

    try {
      final collectionSnapshot = await _collectionRef.get();
      final docs = collectionSnapshot.docs;
      return docs.map((e) => e.data() as Map<String, dynamic>).toList();
    } on Exception catch (e) {
      _handleError(e, 'fetchAll', {});
      return []; // This line is never reached because `_handleError` throws.
    } finally {
      _logCompletionTime(now, 'Fetching all');
    }
  }

  /// Handles errors by logging and rethrowing them.
  ///
  /// If the error is a [FirebaseException], logs its details.
  /// Otherwise, logs the error type and data.
  void _handleError(Exception e, String methodName, Map<String, dynamic> data) {
    if (e is FirebaseException) {
      "🔴 ${e.plugin.toUpperCase()} Message: ${e.message} Code: ${e.code}".log();
    } else {
      '🔴 Error in $methodName with data $data: $e (type ${e.runtimeType})'.log();
    }
    throw e;
  }

  /// Logs the completion time of an operation.
  ///
  /// Logs the duration of the operation in milliseconds.
  void _logCompletionTime(DateTime startTime, String operation) {
    final duration = DateTime.now().difference(startTime).inMilliseconds;
    '$operation command finished in $duration ms'.log();
    if (forTesting) {
      debugPrint('$operation command finished in $duration ms');
    }
  }
}
