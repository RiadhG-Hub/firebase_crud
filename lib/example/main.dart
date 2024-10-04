import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/mixin/crud_repos.dart';
import 'package:firebase_crud/mixin/firestore_read_service.dart';
import 'package:firebase_crud/mixin/firestore_write_service.dart';
import 'package:firebase_crud/mixin/logger_service.dart';
import 'package:logger/logger.dart';

/// Example Repository for managing user data, utilizing Firestore read and write operations.
///
/// This repository uses the `FirestoreReadRepository` and `FirestoreWriteRepository`
/// mixins to perform CRUD operations on the Firestore database, specifically targeting the
/// 'users' collection. It also integrates a logger service for logging operations and errors.
class UserRepository with FirestoreReadRepository, FirestoreWriteRepository {
  /// Specifies the collection name in Firestore.
  @override
  String get collection => 'users';

  /// Returns an instance of the FirestoreReadService implementation.
  @override
  FirestoreReadService get firestoreReadService => FirestoreServiceImpl();

  /// Returns an instance of the FirestoreWriteService implementation.
  @override
  FirestoreWriteService get firestoreWriteService =>
      FirestoreWriteServiceImpl();

  /// Returns an instance of the LoggerService implementation, enabling logging.
  @override
  LoggerService? get loggerService => LoggerServiceImpl(Logger(), true);

  /// Searches for documents in the Firestore 'users' collection based on a specific criteria.
  ///
  /// This method demonstrates how to use Firestore directly, bypassing the mixin functionalities.
  ///
  /// Returns a list of user data as a list of maps.
  Future<List<Map<String, dynamic>>> search() async {
    final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
        .instance
        .collection(collection)
        .where("id", whereIn: ["something"]).get();

    // Maps the document snapshots to a list of maps containing the user data.
    return result.docs.map((element) => element.data()).toList();
  }
}

/// Main function to demonstrate the usage of the UserRepository class.
main() async {
  // Creates an instance of the UserRepository.
  final UserRepository userRepository = UserRepository();

  // Example of saving a new document in the 'users' collection.
  await userRepository.saveDocument(data: {"example": ""});

  // Example of fetching a document by its ID.
  await userRepository.fetchDocumentById(docId: "doc_id");

  // Example of deleting a document by its ID.
  await userRepository.deleteDocument(documentId: "doc_id");

  // Example of fetching all documents from the 'users' collection.
  await userRepository.fetchAllDocuments();
}
