import 'package:cloud_firestore/cloud_firestore.dart';

/// Services for Firestore Write Operations
///
/// This abstract class defines the interface for writing data to Firestore.
/// It includes methods for saving a document and deleting a document
/// from a specified Firestore collection.
abstract class FirestoreWriteService {
  /// Saves a document to the specified Firestore collection.
  ///
  /// [collection]: The name of the Firestore collection.
  /// [data]: A Map containing the document data to be saved. If the data contains an 'id',
  /// the document will be updated, otherwise, a new document will be created.
  ///
  /// Returns a Future that resolves when the operation is complete.
  Future<void> saveDocument(String collection, Map<String, dynamic> data);

  /// Deletes a document from the specified Firestore collection.
  ///
  /// [collection]: The name of the Firestore collection.
  /// [documentId]: The ID of the document to be deleted.
  ///
  /// Returns a Future that resolves when the document is deleted.
  Future<void> deleteDocument(String collection, String documentId);
}

/// Implementation of FirestoreWriteService
///
/// This class provides the concrete implementation of the FirestoreWriteService interface.
/// It uses FirebaseFirestore to interact with Firestore and perform write operations such as
/// saving and deleting documents.
class FirestoreWriteServiceImpl implements FirestoreWriteService {
  /// Saves a document to Firestore.
  ///
  /// This method checks if the provided data contains an 'id' field. If it does, it updates the existing
  /// document with that ID in the Firestore collection. If not, it creates a new document with an
  /// automatically generated ID.
  ///
  /// [collection]: The name of the Firestore collection.
  /// [data]: A Map containing the document data to be saved.
  ///
  /// Returns a Future that resolves when the document is saved.
  @override
  Future<void> saveDocument(String collection, Map<String, dynamic> data) {
    // Determine if the document should be updated or created
    final docRef = data.containsKey('id')
        ? FirebaseFirestore.instance
            .collection(collection)
            .doc(data['id']) // Update existing document
        : FirebaseFirestore.instance
            .collection(collection)
            .doc(); // Create a new document

    // Save the document data, using merge to preserve existing fields if the document exists
    return docRef.set(data, SetOptions(merge: true));
  }

  /// Deletes a document from Firestore by its ID.
  ///
  /// This method deletes a document from the specified Firestore collection using its document ID.
  ///
  /// [collection]: The name of the Firestore collection.
  /// [documentId]: The ID of the document to be deleted.
  ///
  /// Returns a Future that resolves when the document is deleted.
  @override
  Future<void> deleteDocument(String collection, String documentId) {
    // Delete the document from the collection using its ID
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(documentId)
        .delete();
  }
}
