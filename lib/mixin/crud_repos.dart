
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/mixin/firestore_read_service.dart';
import 'package:firebase_crud/mixin/logger_service.dart';
import 'auth_service.dart';
import 'firestore_write_service.dart';

/// Mixin for Firestore Read Operations
mixin FirestoreReadRepository {
  String get collection => '';
  FirestoreReadService get firestoreReadService;
  LoggerService? get loggerService;

  Future<DocumentSnapshot<Object?>> fetchDocumentById({required String docId}) async {
    final now = DateTime.now();
    loggerService?.log("⌛ Fetching document with ID $docId in progress");

    try {
      final result = await firestoreReadService.fetchDocumentById(collection, docId);
      return result;
    } catch (e) {
      final errorMessage = 'Error fetching document with ID $docId';
      loggerService?.logError(errorMessage, e.toString());
      rethrow;
    } finally {
      loggerService?.logCompletionTime(now, 'Fetching document');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllDocuments() async {
    final now = DateTime.now();
    loggerService?.log("⌛ Fetching all documents in progress");

    try {
      final documents = await firestoreReadService.fetchAllDocuments(collection);
      return documents;
    } catch (e) {
      const errorMessage = 'Error fetching all documents';
      loggerService?.logError(errorMessage, e.toString());
      rethrow;
    } finally {
      loggerService?.logCompletionTime(now, 'Fetching all documents');
    }
  }
}

/// Mixin for Firestore Write Operations
mixin FirestoreWriteRepository {
  String get collection => '';
  FirestoreWriteService get firestoreWriteService;
  LoggerService? get loggerService;

  Future<void> saveDocument({required Map<String, dynamic> data}) async {
    final now = DateTime.now();
    loggerService?.log("⌛ Saving document: $data in progress");

    try {
      await firestoreWriteService.saveDocument(collection, data);
      loggerService?.log('✅ Document ${data.containsKey('id') ? data['id'] : "New document"} saved successfully');
    } catch (e) {
      const errorMessage = 'Error saving document';
      loggerService?.logError(errorMessage, e.toString());
      rethrow;
    } finally {
      loggerService?.logCompletionTime(now, 'Saving document');
    }
  }

  Future<void> deleteDocument({required String documentId}) async {
    final now = DateTime.now();
    loggerService?.log("⌛ Deleting document with ID $documentId in progress");

    try {
      await firestoreWriteService.deleteDocument(collection, documentId);
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

/// Mixin for Authentication Operations
mixin AuthRepository {
  AuthService get authService;

  Future<void> checkAuthenticated() async {
    if (!authService.isAuthenticated()) {
      throw Exception('User not authenticated');
    }
  }
}

