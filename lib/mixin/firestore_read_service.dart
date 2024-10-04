import 'package:cloud_firestore/cloud_firestore.dart';

/// Services for Firestore Read Operations
///
/// This abstract class defines the interface for reading data from Firestore.
/// It includes methods for fetching a document by its ID and fetching all documents
/// from a specified collection.
abstract class FirestoreReadService {
  /// Fetches a document from Firestore by its ID.
  ///
  /// [collection]: The name of the Firestore collection.
  /// [docId]: The ID of the document to fetch.
  ///
  /// Returns a Future that resolves to a DocumentSnapshot containing the document data.
  Future<DocumentSnapshot<Object?>> fetchDocumentById(
      String collection, String docId);

  /// Fetches all documents from the specified Firestore collection.
  ///
  /// [collection]: The name of the Firestore collection.
  ///
  /// Returns a Future that resolves to a List of Maps, where each Map represents the data
  /// of a document in the collection.
  Future<List<Map<String, dynamic>>> fetchAllDocuments(String collection);
}

/// Implementation of FirestoreReadService
///
/// This class provides the concrete implementation of the FirestoreReadService interface.
/// It uses FirebaseFirestore to interact with Firestore and fetch document data.
class FirestoreServiceImpl implements FirestoreReadService {
  /// Fetches a document from Firestore by its ID.
  ///
  /// This method uses FirebaseFirestore's instance to retrieve a document by its ID
  /// from the specified Firestore collection.
  ///
  /// [collection]: The name of the Firestore collection.
  /// [docId]: The ID of the document to fetch.
  ///
  /// Returns a Future that resolves to a DocumentSnapshot containing the document data.
  @override
  Future<DocumentSnapshot<Object?>> fetchDocumentById(
      String collection, String docId) {
    // Use FirebaseFirestore to fetch the document by its ID from the collection
    return FirebaseFirestore.instance.collection(collection).doc(docId).get();
  }

  /// Fetches all documents from the specified Firestore collection.
  ///
  /// This method retrieves all the documents from the specified collection and returns their data
  /// as a list of Maps. Each Map corresponds to a document in the collection.
  ///
  /// [collection]: The name of the Firestore collection.
  ///
  /// Returns a Future that resolves to a List of Maps, where each Map represents the data
  /// of a document in the collection.
  @override
  Future<List<Map<String, dynamic>>> fetchAllDocuments(
      String collection) async {
    // Fetch all documents from the specified collection
    final snapshot =
        await FirebaseFirestore.instance.collection(collection).get();
    // Convert the documents to a list of Maps containing their data
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
