import 'package:firebase_crud/mixin/crud_repos.dart';
import 'package:flutter_test/flutter_test.dart';

class UserRepository with CrudRepository {
  final String _collection;

  UserRepository({String collection = 'users'}) : _collection = collection;

  @override
  String get collection => _collection;

  @override
  bool get forTesting => true;
}

void main() {
  group('CrudRepository', () {
    test('saveDocument saves a new document with auto-generated ID', () async {
      final repos = UserRepository(collection: 'test1');

      await repos.saveDocument(
          data: {'name': 'John Doe', 'email': 'john@example.com'});

      final allDocs = await repos.fetchAllDocuments();
      expect(allDocs, isNotEmpty);
      expect(allDocs[0]['name'], 'John Doe');
    });

    test('saveDocument saves a document with provided ID', () async {
      final repos = UserRepository(collection: 'test2');

      await repos.saveDocument(data: {'id': 'user123', 'name': 'Jane Doe'});

      final doc = await repos.fetchDocumentById(docId: 'user123');
      expect(doc.exists, isTrue);
      expect((doc.data() as Map<String, dynamic>?)!['name'], 'Jane Doe');
    });

    test('fetchDocumentById fetches an existing document', () async {
      final repos = UserRepository(collection: 'test3');

      await repos.saveDocument(data: {'id': 'testId', 'field': 'value'});
      final result = await repos.fetchDocumentById(docId: 'testId');

      expect(result.exists, isTrue);
      expect(result.data(), {'id': 'testId', 'field': 'value'});
    });

    test('fetchDocumentById returns non-existent document', () async {
      final repos = UserRepository(collection: 'test4');

      final result = await repos.fetchDocumentById(docId: 'nonexistent');

      expect(result.exists, isFalse);
    });

    test('fetchAllDocuments returns all documents', () async {
      final repos = UserRepository(collection: 'test5');

      await repos.saveDocument(data: {'id': 'doc1', 'name': 'Document 1'});
      await repos.saveDocument(data: {'id': 'doc2', 'name': 'Document 2'});

      final result = await repos.fetchAllDocuments();

      expect(result.length, 2);
      expect(result.map((e) => e['id']), containsAll(['doc1', 'doc2']));
    });

    test('fetchAllDocuments returns empty list for empty collection', () async {
      final repos = UserRepository(collection: 'test6');

      final result = await repos.fetchAllDocuments();

      expect(result, isEmpty);
    });

    test('deleteDocument deletes an existing document', () async {
      final repos = UserRepository(collection: 'test7');

      await repos.saveDocument(data: {'id': 'toDelete', 'name': 'To Delete'});
      await repos.deleteDocument(documentId: 'toDelete');

      final result = await repos.fetchDocumentById(docId: 'toDelete');

      expect(result.exists, isFalse);
    });

    test('isExist returns true for existing document', () async {
      final repos = UserRepository(collection: 'test8');

      await repos.saveDocument(data: {'id': 'exists', 'name': 'Exists'});
      final result = await repos.isExist(documentId: 'exists');

      expect(result, isTrue);
    });

    test('isExist returns false for non-existent document', () async {
      final repos = UserRepository(collection: 'test9');

      final result = await repos.isExist(documentId: 'nonexistent');

      expect(result, isFalse);
    });

    test('deprecated methods work correctly', () async {
      final repos = UserRepository(collection: 'test10');

      // Test deprecated add method
      await repos.add(data: {'id': 'deprecated1', 'field': 'value'});
      var result = await repos.docById(docId: 'deprecated1');
      expect(result.exists, isTrue);

      // Test deprecated fetchAll method
      await repos.add(data: {'id': 'deprecated2', 'field': 'value2'});
      final allDocs = await repos.fetchAll();
      expect(allDocs.length, 2);

      // Test deprecated delete method
      await repos.delete(documentID: 'deprecated1');
      result = await repos.docById(docId: 'deprecated1');
      expect(result.exists, isFalse);
    });
  });
}
