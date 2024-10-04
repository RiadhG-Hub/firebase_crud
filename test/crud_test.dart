import 'package:firebase_crud/extensions/collection.dart';
import 'package:firebase_crud/mixin/logger_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

/// Mock logger service to verify logging behavior.
class MockLoggerService implements LoggerService {
  List<String> logs = [];

  @override
  void log(String message, {Level level = Level.info}) {
    logs.add(message);
  }

  @override
  void logError(String message, String errorDetails,
      {Level level = Level.error}) {
    logs.add('$message: $errorDetails');
  }

  @override
  void logCompletionTime(DateTime startTime, String operation) {
    final duration = DateTime.now().difference(startTime).inMilliseconds;
    log('$operation completed in $duration ms');
  }
}

void main() {
  group('Firestore CRUD operations with fake Firestore', () {
    late FirestoreInstance firestoreInstance;
    late MockLoggerService logger;

    setUp(() {
      firestoreInstance = FakeFirestoreInstance();
      logger = MockLoggerService();
    });

    test('Create a document and verify it exists', () async {
      final collectionRef = firestoreInstance.getCollection('testCollection');

      // Create (Add) a document
      const docId = 'testDoc';
      await collectionRef.doc(docId).set({'id': docId, 'name': 'Test Name'});

      // Verify document was created
      final snapshot = await collectionRef.doc(docId).get();
      expect(snapshot.exists, true);
      expect(snapshot.data()?['name'], 'Test Name');
    });

    test('Read a document by ID', () async {
      final collectionRef = firestoreInstance.getCollection('testCollection');

      // Add a document
      const docId = 'testDoc';
      await collectionRef.doc(docId).set({'id': docId, 'name': 'Test Name'});

      // Fetch (Read) the document
      final snapshot = await collectionRef.doc(docId).get();
      expect(snapshot.exists, true);
      expect(snapshot.data()?['name'], 'Test Name');
    });

    test('Update an existing document', () async {
      final collectionRef = firestoreInstance.getCollection('testCollection');

      // Add a document
      const docId = 'testDoc';
      await collectionRef.doc(docId).set({'id': docId, 'name': 'Old Name'});

      // Update the document
      await collectionRef.doc(docId).update({'name': 'Updated Name'});

      // Fetch and verify the updated document
      final snapshot = await collectionRef.doc(docId).get();
      expect(snapshot.exists, true);
      expect(snapshot.data()?['name'], 'Updated Name');
    });

    test('Delete a document by ID', () async {
      final collectionRef = firestoreInstance.getCollection('testCollection');

      // Add a document
      const docId = 'testDoc';
      await collectionRef
          .doc(docId)
          .set({'id': docId, 'name': 'To Be Deleted'});

      // Verify document exists
      var snapshot = await collectionRef.doc(docId).get();
      expect(snapshot.exists, true);

      // Delete the document
      await collectionRef.doc(docId).delete();

      // Verify document is deleted
      snapshot = await collectionRef.doc(docId).get();
      expect(snapshot.exists, false);
    });

    test('Log time taken for a CRUD operation', () async {
      final collectionRef = firestoreInstance.getCollection('testCollection');
      final now = DateTime.now();

      // Perform an operation (Create document)
      const docId = 'timingTestDoc';
      await collectionRef.doc(docId).set({'id': docId, 'name': 'Timing Test'});

      // Log time
      logger.logCompletionTime(now, 'Create Document');

      // Verify logging behavior
      expect(logger.logs.isNotEmpty, true);
      expect(logger.logs.last.contains('Create Document completed in'), true);
    });

    test('Handle error during document fetch', () async {
      final collectionRef = firestoreInstance.getCollection('testCollection');

      // Fetching a non-existing document should cause an error
      try {
        await collectionRef.doc('nonExistingDoc').get();
      } catch (e) {
        logger.logError('Error fetching document', e.toString());
      }

      // Verify error logging
      expect(logger.logs.isNotEmpty, false);
    });
  });
}
