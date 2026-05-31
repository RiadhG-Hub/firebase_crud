import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/extensions/collection.dart';
import 'package:logger/logger.dart';

/// A mixin providing CRUD operations for a Firestore collection with optional logging and enhanced error tracking.
///
/// Use this mixin in your repository classes to gain access to common Firebase Firestore operations.
///
/// Example:
/// ```dart
/// class UserRepository with CrudRepository {
///   @override
///   String get collection => 'users';
///
///   @override
///   bool get enableLogging => true;
///
///   @override
///   Logger? get logger => Logger();
/// }
/// ```
mixin class CrudRepository {
  /// The name of the collection in Firestore.
  ///
  /// Must be overridden in the implementing class.
  String get collection => '';

  /// Flag indicating whether the operations are for testing purposes.
  ///
  /// When true, uses [FakeFirebaseFirestore] instead of the real Firebase instance.
  /// Defaults to false.
  bool get forTesting => false;

  /// Optional logger instance for logging operations.
  ///
  /// If null, logging is disabled regardless of [enableLogging] value.
  Logger? get logger => null;

  /// Flag indicating whether logging is enabled.
  ///
  /// When true and [logger] is not null, operations will be logged.
  /// Defaults to false.
  bool get enableLogging => false;

  /// Gets the reference to the Firestore collection.
  CollectionReference<Object?> get _collectionRef =>
      collection.collection(forTesting: forTesting);

  /// Logs a message if logging is enabled.
  void _log(String message, {Level level = Level.info}) {
    if (enableLogging && logger != null) {
      logger!.log(level, message);
    }
  }

  /// Logs the error details with enhanced context for better debugging.
  void _handleError(dynamic e, String methodName, Map<String, dynamic> data) {
    if (e is FirebaseException) {
      _log('🔴 FirebaseError in $methodName with data $data: ${e.message}',
          level: Level.error);
      _log(
          'Error details: code = ${e.code}, message = ${e.message}, plugin = ${e.plugin}',
          level: Level.error);
    } else {
      _log(
          '🔴 Error in $methodName with data $data: $e (type ${e.runtimeType})',
          level: Level.error);
    }
  }

  /// Logs the time taken for an operation.
  void _logCompletionTime(DateTime startTime, String operation) {
    final duration = DateTime.now().difference(startTime).inMilliseconds;
    _log('$operation completed in $duration ms');
  }

  /// Fetches a document by its ID.
  ///
  /// Parameters:
  ///   - [docId]: The unique identifier of the document to fetch.
  ///
  /// Returns a [DocumentSnapshot] containing the document data.
  ///
  /// Throws an exception if the operation fails.
  Future<DocumentSnapshot<Object?>> fetchDocumentById(
      {required String docId}) async {
    final now = DateTime.now();
    _log("⌛ Fetching document with ID $docId in progress");

    try {
      final result = await _collectionRef.doc(docId).get();
      return result;
    } catch (e) {
      _handleError(e, 'fetchDocumentById', {'docId': docId});
      rethrow;
    } finally {
      _logCompletionTime(now, 'Fetching document');
    }
  }

  /// Adds or updates a document.
  ///
  /// If the document data contains an 'id' field, it will be used as the document ID.
  /// Otherwise, a new document with an auto-generated ID will be created.
  ///
  /// Parameters:
  ///   - [data]: A map containing the document data. Merge is enabled by default.
  ///
  /// Throws an exception if the operation fails.
  Future<void> saveDocument({required Map<String, dynamic> data}) async {
    final now = DateTime.now();
    _log("⌛ Saving document: $data in progress");

    try {
      final docRef = data.containsKey('id')
          ? _collectionRef.doc(data['id'])
          : _collectionRef.doc();
      await docRef.set(data, SetOptions(merge: true));
      _log(
          '✅ Document ${data.containsKey('id') ? data['id'] : "New document"} saved successfully');
    } catch (e) {
      _handleError(e, 'saveDocument', data);
      rethrow;
    } finally {
      _logCompletionTime(now, 'Saving document');
    }
  }

  /// Fetches all documents in the collection.
  ///
  /// Returns a list of maps containing all documents in the collection.
  /// If the collection is empty, returns an empty list.
  ///
  /// Throws an exception if the operation fails.
  Future<List<Map<String, dynamic>>> fetchAllDocuments() async {
    final now = DateTime.now();
    _log("⌛ Fetching all documents in progress");

    try {
      final collectionSnapshot = await _collectionRef.get();
      return collectionSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      _handleError(e, 'fetchAllDocuments', {});
      rethrow;
    } finally {
      _logCompletionTime(now, 'Fetching all documents');
    }
  }

  /// Deletes a document by its ID.
  ///
  /// Parameters:
  ///   - [documentId]: The unique identifier of the document to delete.
  ///
  /// Throws an exception if the operation fails.
  Future<void> deleteDocument({required String documentId}) async {
    final now = DateTime.now();
    _log("⌛ Deleting document with ID $documentId in progress");

    try {
      await _collectionRef.doc(documentId).delete();
      _log('✅ Document with ID $documentId deleted successfully');
    } catch (e) {
      _handleError(e, 'deleteDocument', {'documentId': documentId});
      rethrow;
    } finally {
      _logCompletionTime(now, 'Deleting document');
    }
  }

  /// Deprecated methods for backward compatibility.

  @Deprecated('Use fetchDocumentById instead')
  Future<DocumentSnapshot<Object?>> docById({required String docId}) =>
      fetchDocumentById(docId: docId);

  @Deprecated('Use saveDocument instead')
  Future<void> add({required Map<String, dynamic> data}) =>
      saveDocument(data: data);

  @Deprecated('Use fetchAllDocuments instead')
  Future<List<dynamic>> fetchAll() => fetchAllDocuments();

  @Deprecated('Use deleteDocument instead')
  Future<void> delete({required String documentID}) =>
      deleteDocument(documentId: documentID);

  @Deprecated(
      'Manually check document existence using fetchDocumentById or other methods')
  Future<bool> isExist({required String documentId}) async {
    try {
      final result = await fetchDocumentById(docId: documentId);
      final exist = result.exists;
      _log('✅ Document with ID $documentId exists: $exist');
      return exist;
    } catch (e) {
      _handleError(e, 'isExist', {'documentId': documentId});
      rethrow;
    }
  }
}
