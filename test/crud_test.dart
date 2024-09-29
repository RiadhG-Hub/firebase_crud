import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/mixin/crud_repos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'crud_test.mocks.dart';

class TestCrudRepos with CrudRepository {
  @override
  String get collection => 'test';
  @override
  bool get forTesting => true;
}

@GenerateMocks([CollectionReference, DocumentReference, DocumentSnapshot, QuerySnapshot])
void main() {
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocument;
  late MockDocumentSnapshot mockSnapshot;
  late MockQuerySnapshot mockQuerySnapshot;

  setUp(() {
    mockCollection = MockCollectionReference();
    mockDocument = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();
    mockQuerySnapshot = MockQuerySnapshot();
  });

  // A test class to use the mixin
  TestCrudRepos createTestInstance() {
    final instance = TestCrudRepos();
    return instance;
  }

  group('CrudRepository', () {
    test('add adds a new document', () async {
      final repos = createTestInstance();
      when(mockCollection.doc('testId')).thenReturn(mockDocument);
      when(mockDocument.set(any, any)).thenAnswer((_) async {});
      await repos.saveDocument(
        data: {'field': 'value', 'id': 'testId'},
      );
      verify(mockDocument.set({'field': 'value', 'id': 'testId'}, SetOptions(merge: true))).called(1);
    });

    test('docById returns a document snapshot', () async {
      final repos = createTestInstance();
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.data()).thenReturn({'field': 'value', 'id': 'testId'});
      final result = await repos.fetchDocumentById(docId: 'testId');
      expect(result, isA<DocumentSnapshot>());
      expect(result.data(), {'field': 'value', 'id': 'testId'});
    });

    test('fetchDocumentById fetches document data', () async {
      final repos = createTestInstance();
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.data()).thenReturn({'field': 'value', 'id': 'testId'});
      final result = await repos.fetchDocumentById(docId: 'testId');
      expect(result.data(), {'field': 'value', 'id': 'testId'});
    });

    test('fetchAll fetches all document data', () async {
      final repos = createTestInstance();
      when(mockCollection.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([]);

      final result = await repos.fetchAllDocuments();
      expect(result, [
        {'field': 'value', 'id': 'testId'}
      ]);
    });

    test('delete deletes a document', () async {
      final repos = createTestInstance();
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.delete()).thenAnswer((_) async {});
      await repos.deleteDocument(documentId: 'testId');
      verify(mockDocument.delete()).called(1);
    });

    test('saveDocument updates a document', () async {
      final repos = createTestInstance();
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.set(any, any)).thenAnswer((_) async {});
      await repos.saveDocument(data: {'id': 'testId', 'field': 'newValue'});
      verify(mockDocument.set({'id': 'testId', 'field': 'newValue'}, SetOptions(merge: true))).called(1);
    });

    test('isExist checks document existence', () async {
      final repos = createTestInstance();
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(true);
      final result = await repos.isExist(documentId: 'testId');
      expect(result, isTrue);
    });
  });
}
