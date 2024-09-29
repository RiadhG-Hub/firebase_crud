import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/extensions/collection.dart';
import 'package:logger/logger.dart';

/// A mixin providing CRUD operations for a Firestore collection with optional logging and enhanced error tracking.
mixin class CrudRepository {
  /// The name of the collection in Firestore.
  String get collection => '';

  /// Flag indicating whether the operations are for testing purposes.
  bool get forTesting => false;

  /// Optional logger instance for logging operations.
  Logger? get logger => null;

  /// Flag indicating whether logging is enabled.
  bool get enableLogging => false;

  /// Gets the reference to the Firestore collection.
  CollectionReference<Object?> get _collectionRef => collection.collection(forTesting: forTesting);

  /// Logs a message if logging is enabled.
  void _log(String message, {Level level = Level.info}) {
    if (enableLogging && logger != null) {
      logger!.log(level, message);
    }
  }

  /// Logs the error details with enhanced context for better debugging.
  void _handleError(dynamic e, String methodName, Map<String, dynamic> data) {
    if (e is FirebaseException) {
      _log('🔴 FirebaseError in $methodName with data $data: ${e.message}', level: Level.error);
      _log('Error details: code = ${e.code}, message = ${e.message}, plugin = ${e.plugin}', level: Level.error);
    } else {
      _log('🔴 Error in $methodName with data $data: $e (type ${e.runtimeType})', level: Level.error);
    }
  }

  /// Logs the time taken for an operation.
  void _logCompletionTime(DateTime startTime, String operation) {
    final duration = DateTime.now().difference(startTime).inMilliseconds;
    _log('$operation completed in $duration ms');
  }

  /// Fetches a document by its ID.
  Future<DocumentSnapshot<Object?>> fetchDocumentById({required String docId}) async {
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
  Future<void> saveDocument({required Map<String, dynamic> data}) async {
    final now = DateTime.now();
    _log("⌛ Saving document: $data in progress");

    try {
      final docRef = data.containsKey('id') ? _collectionRef.doc(data['id']) : _collectionRef.doc();
      await docRef.set(data, SetOptions(merge: true));
      _log('✅ Document ${data.containsKey('id') ? data['id'] : "New document"} saved successfully');
    } catch (e) {
      _handleError(e, 'saveDocument', data);
      rethrow;
    } finally {
      _logCompletionTime(now, 'Saving document');
    }
  }

  /// Fetches all documents in the collection.
  Future<List<Map<String, dynamic>>> fetchAllDocuments() async {
    final now = DateTime.now();
    _log("⌛ Fetching all documents in progress");

    try {
      final collectionSnapshot = await _collectionRef.get();
      return collectionSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      _handleError(e, 'fetchAllDocuments', {});
      rethrow;
    } finally {
      _logCompletionTime(now, 'Fetching all documents');
    }
  }

  /// Deletes a document by its ID.
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
  Future<DocumentSnapshot<Object?>> docById({required String docId}) => fetchDocumentById(docId: docId);

  @Deprecated('Use saveDocument instead')
  Future<void> add({required Map<String, dynamic> data}) => saveDocument(data: data);

  @Deprecated('Use fetchAllDocuments instead')
  Future<List<dynamic>> fetchAll() => fetchAllDocuments();

  @Deprecated('Use deleteDocument instead')
  Future<void> delete({required String documentID}) => deleteDocument(documentId: documentID);

  @Deprecated('Manually check document existence using fetchDocumentById or other methods')
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
