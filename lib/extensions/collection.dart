import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

/// Singleton instance of [FakeFirebaseFirestore] for testing purposes.
final _fakeFirestore = FakeFirebaseFirestore();

/// Extension on [String] to get a Firestore collection reference.
///
/// This extension provides a convenient way to access Firestore collections.
/// When [forTesting] is true, it uses a fake Firestore instance for unit testing.
/// Otherwise, it uses the real Firebase Firestore instance.
extension Path on String {
  /// Gets a collection reference from Firestore.
  ///
  /// Parameters:
  ///   - [forTesting]: When true, uses [FakeFirebaseFirestore] for testing. Defaults to false.
  ///
  /// Returns a [CollectionReference] that can be used to perform CRUD operations.
  CollectionReference<Map<String, dynamic>> collection(
      {bool forTesting = false}) {
    if (forTesting) {
      return _fakeFirestore.collection(this);
    } else {
      return FirebaseFirestore.instance.collection(this);
    }
  }
}
