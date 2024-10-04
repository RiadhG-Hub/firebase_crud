import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/mixin/firestore_read_service.dart';
import 'package:firebase_crud/mixin/logger_service.dart';
import 'auth_service.dart';
import 'firestore_write_service.dart';

/// Mixin for Firestore Read Operations
///
/// This mixin provides functionalities for reading documents
/// from a Firestore collection. It allows for fetching individual
/// documents by ID and fetching all documents from a collection.
mixin FirestoreReadRepository {
  /// The name of the Firestore collection.
  /// This should be overridden by classes that implement this mixin.
  String get collection => '';

  /// Instance of FirestoreReadService used to perform read operations.
  FirestoreReadService get firestoreReadService;

  /// Optional LoggerService for logging events, errors, and timing.
  LoggerService? get loggerService;

  /// Fetches a document from Firestore by its ID.
  ///
  /// This method logs the progress, performs the fetch operation,
  /// and handles errors. The logger also records the completion time.
  ///
  /// [docId]: The ID of the document to fetch.
  ///
  /// Returns a Future of DocumentSnapshot containing the document data.
  Future<DocumentSnapshot<Object?>> fetchDocumentById(
      {required String docId}) async {
    // Log the start of the fetch operation
    final now = DateTime.now();
    loggerService?.log("⌛ Fetching document with ID $docId in progress");

    try {
      // Fetch document from Firestore
      final result =
          await firestoreReadService.fetchDocumentById(collection, docId);
      return result;
    } catch (e) {
      // Log any error encountered during the fetch
      final errorMessage = 'Error fetching document with ID $docId';
      loggerService?.logError(errorMessage, e.toString());
      // Rethrow the error for further handling
      rethrow;
    } finally {
      // Log the completion time of the fetch operation
      loggerService?.logCompletionTime(now, 'Fetching document');
    }
  }

  /// Fetches all documents from the Firestore collection.
  ///
  /// This method logs the progress, performs the fetch operation,
  /// and handles errors. The logger also records the completion time.
  ///
  /// Returns a Future list of all document data as a List of Maps.
  Future<List<Map<String, dynamic>>> fetchAllDocuments() async {
    // Log the start of the fetch operation
    final now = DateTime.now();
    loggerService?.log("⌛ Fetching all documents in progress");

    try {
      // Fetch all documents from Firestore
      final documents =
          await firestoreReadService.fetchAllDocuments(collection);
      return documents;
    } catch (e) {
      // Log any error encountered during the fetch
      const errorMessage = 'Error fetching all documents';
      loggerService?.logError(errorMessage, e.toString());
      // Rethrow the error for further handling
      rethrow;
    } finally {
      // Log the completion time of the fetch operation
      loggerService?.logCompletionTime(now, 'Fetching all documents');
    }
  }
}

/// Mixin for Firestore Write Operations
///
/// This mixin provides functionalities for writing documents
/// to a Firestore collection. It allows for saving and deleting documents,
/// with logging support for tracking the progress and completion of operations.
mixin FirestoreWriteRepository {
  /// The name of the Firestore collection.
  /// This should be overridden by classes that implement this mixin.
  String get collection => '';

  /// Instance of FirestoreWriteService used to perform write operations.
  FirestoreWriteService get firestoreWriteService;

  /// Optional LoggerService for logging events, errors, and timing.
  LoggerService? get loggerService;

  /// Saves a document to Firestore.
  ///
  /// This method logs the progress, performs the save operation,
  /// and handles errors. The logger also records the completion time.
  ///
  /// [data]: The document data to be saved as a Map.
  ///
  /// Returns a Future that completes when the document is saved.
  Future<void> saveDocument({required Map<String, dynamic> data}) async {
    // Log the start of the save operation
    final now = DateTime.now();
    loggerService?.log("⌛ Saving document: $data in progress");

    try {
      // Save document to Firestore
      await firestoreWriteService.saveDocument(collection, data);
      // Log the success of the operation
      loggerService?.log(
          '✅ Document ${data.containsKey('id') ? data['id'] : "New document"} saved successfully');
    } catch (e) {
      // Log any error encountered during the save
      const errorMessage = 'Error saving document';
      loggerService?.logError(errorMessage, e.toString());
      // Rethrow the error for further handling
      rethrow;
    } finally {
      // Log the completion time of the save operation
      loggerService?.logCompletionTime(now, 'Saving document');
    }
  }

  /// Deletes a document from Firestore by its ID.
  ///
  /// This method logs the progress, performs the delete operation,
  /// and handles errors. The logger also records the completion time.
  ///
  /// [documentId]: The ID of the document to delete.
  ///
  /// Returns a Future that completes when the document is deleted.
  Future<void> deleteDocument({required String documentId}) async {
    // Log the start of the delete operation
    final now = DateTime.now();
    loggerService?.log("⌛ Deleting document with ID $documentId in progress");

    try {
      // Delete document from Firestore
      await firestoreWriteService.deleteDocument(collection, documentId);
      // Log the success of the operation
      loggerService?.log('✅ Document with ID $documentId deleted successfully');
    } catch (e) {
      // Log any error encountered during the delete
      final errorMessage = 'Error deleting document with ID $documentId';
      loggerService?.logError(errorMessage, e.toString());
      // Rethrow the error for further handling
      rethrow;
    } finally {
      // Log the completion time of the delete operation
      loggerService?.logCompletionTime(now, 'Deleting document');
    }
  }
}

/// Mixin for Authentication Operations
///
/// This mixin provides functionalities for checking the user's
/// authentication status. It ensures that the user is authenticated
/// before proceeding with any operations.
mixin AuthRepository {
  /// Instance of AuthService used to check authentication status.
  AuthService get authService;

  /// Ensures the user is authenticated.
  ///
  /// If the user is not authenticated, an exception is thrown.
  ///
  /// Returns a Future that completes if the user is authenticated.
  Future<void> checkAuthenticated() async {
    // Check if the user is authenticated
    if (!authService.isAuthenticated()) {
      // Throw an exception if the user is not authenticated
      throw Exception('User not authenticated');
    }
  }
}
