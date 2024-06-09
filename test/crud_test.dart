import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/mixin/crud_repos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'crud_test.mocks.dart';

class TestCrudRepos with CrudRepos {
  @override
  String collection = 'test';
  @override
  bool forTesting = true;
}

@GenerateMocks([CollectionReference, DocumentReference, DocumentSnapshot])
void main() {
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocument;
  late MockDocumentSnapshot mockSnapshot;

  setUp(() {
    mockCollection = MockCollectionReference();
    mockDocument = MockDocumentReference();
    mockSnapshot = MockDocumentSnapshot();
  });

  // A test class to use the mixin

  TestCrudRepos createTestInstance() {
    final instance = TestCrudRepos();
    // Override the collection getter to return the mock
    instance.collection = 'test';
    return instance;
  }

  group('CrudRepos', () {
    test('add adds a new document', () async {
      final repos = createTestInstance();
      //when(mockCollection.doc('testId')).thenReturn(mockDocument);
      //when(mockDocument.set(any, any)).thenAnswer((_) async {});
      await repos.add(
        data: {'field': 'value', 'id': 'testId'},
      );
    });

    test('docById returns a document snapshot', () async {
      final repos = createTestInstance();
      //when(mockCollection.doc(any)).thenReturn(mockDocument);
      //when(mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.data()).thenReturn({'field': 'value', 'id': 'testId'});
      final result = await repos.docById(docId: 'testId');
      expect(result, isA<DocumentSnapshot>());
      print(result.data());
    });

    test('fetch fetches document data', () async {
      final repos = createTestInstance();
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.data()).thenReturn({'field': 'value', 'id': 'testId'});
      final result = await repos.fetch(documentId: 'testId');
      expect(result, {'field': 'value', 'id': 'testId'});
    });

    test('fetch all document data', () async {
      final repos = createTestInstance();
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.data()).thenReturn({'field': 'value', 'id': 'testId'});
      final result = await repos.fetchAll();
      expect(result, {'field': 'value', 'id': 'testId'});
    });

    test('delete deletes a document', () async {
      final repos = createTestInstance();
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.delete()).thenAnswer((_) async {});
      await repos.delete(documentID: 'testId');
    });

    test('updateData updates a document', () async {
      final repos = createTestInstance();
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.update(any)).thenAnswer((_) async {});
      await repos.updateData(data: {'id': 'testId', 'field': 'newValue'});
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
