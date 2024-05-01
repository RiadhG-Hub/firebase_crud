import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

extension Path on String {
  CollectionReference<Map<String, dynamic>> collection({bool forTesting = false}) {
    if (forTesting) {
      final instance = FakeFirebaseFirestore();
      instance.saveDocument('/');
      return instance.collection(this);
    } else {
      return FirebaseFirestore.instance.collection(this);
    }
  }
}
