import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

/// Abstraction for Firestore instance
abstract class FirestoreInstance {
  CollectionReference<Map<String, dynamic>> getCollection(String path);
}

/// Implementation for real Firestore
class RealFirestoreInstance implements FirestoreInstance {
  @override
  CollectionReference<Map<String, dynamic>> getCollection(String path) {
    return FirebaseFirestore.instance.collection(path);
  }
}

/// Implementation for fake Firestore (used for testing)
class FakeFirestoreInstance implements FirestoreInstance {
  final FakeFirebaseFirestore _fakeFirestore;

  FakeFirestoreInstance() : _fakeFirestore = FakeFirebaseFirestore();

  @override
  CollectionReference<Map<String, dynamic>> getCollection(String path) {
    _fakeFirestore.saveDocument('/');
    return _fakeFirestore.collection(path);
  }
}

/// Factory to decide which Firestore instance to use
class FirestoreFactory {
  final bool forTesting;

  FirestoreFactory({this.forTesting = false});

  FirestoreInstance create() {
    return forTesting ? FakeFirestoreInstance() : RealFirestoreInstance();
  }
}

/// Extension on String to use the FirestoreFactory
extension PathExtension on String {
  CollectionReference<Map<String, dynamic>> collection({bool forTesting = false}) {
    final firestore = FirestoreFactory(forTesting: forTesting).create();
    return firestore.getCollection(this);
  }
}
