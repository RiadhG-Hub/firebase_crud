import 'package:cloud_firestore/cloud_firestore.dart';

/// Services for Firestore Read Operations
abstract class FirestoreReadService {
  Future<DocumentSnapshot<Object?>> fetchDocumentById(String collection, String docId);
  Future<List<Map<String, dynamic>>> fetchAllDocuments(String collection);
}

class FirestoreServiceImpl implements FirestoreReadService {
  @override
  Future<DocumentSnapshot<Object?>> fetchDocumentById(String collection, String docId) {
    return FirebaseFirestore.instance.collection(collection).doc(docId).get();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAllDocuments(String collection) async {
    final snapshot = await FirebaseFirestore.instance.collection(collection).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}