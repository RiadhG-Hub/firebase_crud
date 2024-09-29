import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/extensions/collection.dart';
import 'package:logger/logger.dart';

/// Abstraction for Firestore operations
abstract class FirestoreService {
  CollectionReference<Object?> getCollectionReference(String collection, bool forTesting);
  Future<DocumentSnapshot<Object?>> fetchDocumentById(String collection, String docId);
  Future<void> saveDocument(String collection, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> fetchAllDocuments(String collection);
  Future<void> deleteDocument(String collection, String documentId);
}

/// FirestoreService implementation for Firestore operations
class FirestoreServiceImpl implements FirestoreService {
  @override
  CollectionReference<Object?> getCollectionReference(String collection, bool forTesting) {
    return collection.collection(forTesting: forTesting);
  }

  @override
  Future<DocumentSnapshot<Object?>> fetchDocumentById(String collection, String docId) {
    return getCollectionReference(collection, false).doc(docId).get();
  }

  @override
  Future<void> saveDocument(String collection, Map<String, dynamic> data) {
    final docRef = data.containsKey('id')
        ? getCollectionReference(collection, false).doc(data['id'])
        : getCollectionReference(collection, false).doc();
    return docRef.set(data, SetOptions(merge: true));
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAllDocuments(String collection) async {
    final snapshot = await getCollectionReference(collection, false).get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Future<void> deleteDocument(String collection, String documentId) {
    return getCollectionReference(collection, false).doc(documentId).delete();
  }
}

/// Abstraction for logging functionality
abstract class LoggerService {
  void log(String message, {Level level});
  void logError(String message, String errorDetails, {Level level});
  void logCompletionTime(DateTime startTime, String operation);
}

/// LoggerService implementation using the Logger package
class LoggerServiceImpl implements LoggerService {
  final Logger _logger;
  final bool _enableLogging;

  LoggerServiceImpl(this._logger, this._enableLogging);

  @override
  void log(String message, {Level level = Level.info}) {
    if (_enableLogging) {
      _logger.log(level, message);
    }
  }

  @override
  void logError(String message, String errorDetails, {Level level = Level.error}) {
    if (_enableLogging) {
      _logger.log(level, "$message. Details: $errorDetails");
    }
  }

  @override
  void logCompletionTime(DateTime startTime, String operation) {
    final duration = DateTime.now().difference(startTime).inMilliseconds;
    log('$operation completed in $duration ms');
  }
}

/// A mixin providing CRUD operations for a Firestore collection with optional logging.
mixin CrudRepository {
  String get collection => '';
  bool get forTesting => false;

  FirestoreService get firestoreService;
  LoggerService? get loggerService;

  Future<DocumentSnapshot<Object?>> fetchDocumentById({required String docId}) async {
    final now = DateTime.now();
    loggerService?.log("⌛ Fetching document with ID $docId in progress");

    try {
      final result = await firestoreService.fetchDocumentById(collection, docId);
      return result;
    } catch (e) {
      final errorMessage = 'Error fetching document with ID $docId';
      loggerService?.logError(errorMessage, e.toString());
      rethrow;
    } finally {
      loggerService?.logCompletionTime(now, 'Fetching document');
    }
  }

  Future<void> saveDocument({required Map<String, dynamic> data}) async {
    final now = DateTime.now();
    loggerService?.log("⌛ Saving document: $data in progress");

    try {
      await firestoreService.saveDocument(collection, data);
      loggerService?.log('✅ Document ${data.containsKey('id') ? data['id'] : "New document"} saved successfully');
    } catch (e) {
      const errorMessage = 'Error saving document';
      loggerService?.logError(errorMessage, e.toString());
      rethrow;
    } finally {
      loggerService?.logCompletionTime(now, 'Saving document');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllDocuments() async {
    final now = DateTime.now();
    loggerService?.log("⌛ Fetching all documents in progress");

    try {
      final documents = await firestoreService.fetchAllDocuments(collection);
      return documents;
    } catch (e) {
      const errorMessage = 'Error fetching all documents';
      loggerService?.logError(errorMessage, e.toString());
      rethrow;
    } finally {
      loggerService?.logCompletionTime(now, 'Fetching all documents');
    }
  }

  Future<void> deleteDocument({required String documentId}) async {
    final now = DateTime.now();
    loggerService?.log("⌛ Deleting document with ID $documentId in progress");

    try {
      await firestoreService.deleteDocument(collection, documentId);
      loggerService?.log('✅ Document with ID $documentId deleted successfully');
    } catch (e) {
      final errorMessage = 'Error deleting document with ID $documentId';
      loggerService?.logError(errorMessage, e.toString());
      rethrow;
    } finally {
      loggerService?.logCompletionTime(now, 'Deleting document');
    }
  }
}
