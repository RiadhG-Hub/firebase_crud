import 'package:cloud_firestore/cloud_firestore.dart';

/// Services for Firestore Write Operations
abstract class FirestoreWriteService {
  Future<void> saveDocument(String collection, Map<String, dynamic> data);
  Future<void> deleteDocument(String collection, String documentId);
}

class FirestoreWriteServiceImpl implements FirestoreWriteService {
  @override
  Future<void> saveDocument(String collection, Map<String, dynamic> data) {
    final docRef = data.containsKey('id')
        ? FirebaseFirestore.instance.collection(collection).doc(data['id'])
        : FirebaseFirestore.instance.collection(collection).doc();
    return docRef.set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteDocument(String collection, String documentId) {
    return FirebaseFirestore.instance.collection(collection).doc(documentId).delete();
  }
}