# Firebase CRUD

A comprehensive Dart/Flutter package providing streamlined CRUD (Create, Read, Update, Delete) operations for Firebase Firestore with built-in logging, error handling, and type safety.

## Features

- ✅ **Complete CRUD Operations**: Create, read, update, and delete documents with ease
- ✅ **Real-time Updates**: Leverages Firestore's real-time synchronization capabilities
- ✅ **Comprehensive Error Handling**: Detailed error logging and exception handling
- ✅ **Flexible Logging**: Optional built-in logging with configurable log levels
- ✅ **Testing Support**: Integrated support for unit testing with FakeFirebaseFirestore
- ✅ **Type-Safe**: Built with strong typing and null safety in mind
- ✅ **Mixin-Based Architecture**: Easy to integrate into existing repositories

## Installation

Add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
  firebase_crud: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Create a Repository Class

```dart
import 'package:firebase_crud/firebase_crud.dart';
import 'package:logger/logger.dart';

class UserRepository with CrudRepository {
  @override
  String get collection => 'users';
  
  @override
  bool get forTesting => false;
  
  @override
  bool get enableLogging => true;
  
  @override
  Logger get logger => Logger();
}
```

### 2. Use CRUD Operations

```dart
final userRepo = UserRepository();

// Create/Update a document
await userRepo.saveDocument(data: {
  'id': 'user123',
  'name': 'John Doe',
  'email': 'john@example.com'
});

// Fetch a single document
final user = await userRepo.fetchDocumentById(docId: 'user123');
print(user.data());

// Fetch all documents
final allUsers = await userRepo.fetchAllDocuments();
print('Total users: ${allUsers.length}');

// Delete a document
await userRepo.deleteDocument(documentId: 'user123');
```

## API Reference

### CrudRepository Mixin Methods

#### saveDocument
Adds or updates a document in the collection. If the document contains an 'id' field, it updates the document with that ID. Otherwise, creates a new document with an auto-generated ID.

```dart
Future<void> saveDocument({required Map<String, dynamic> data})
```

#### fetchDocumentById
Retrieves a single document by its ID.

```dart
Future<DocumentSnapshot> fetchDocumentById({required String docId})
```

#### fetchAllDocuments
Retrieves all documents from the collection.

```dart
Future<List<Map<String, dynamic>>> fetchAllDocuments()
```

#### deleteDocument
Deletes a document by its ID.

```dart
Future<void> deleteDocument({required String documentId})
```

## Configuration

### CrudRepository Getters

When using the `CrudRepository` mixin, override these getters to configure behavior:

- **collection**: The Firestore collection name (required)
- **forTesting**: Set to `true` to use FakeFirebaseFirestore for unit tests (default: false)
- **enableLogging**: Set to `true` to enable detailed logging (default: false)
- **logger**: Provide a Logger instance for logging operations (default: null)

## Error Handling

The package automatically catches and logs errors with detailed context:

```dart
try {
  await userRepo.saveDocument(data: {'id': 'user123'});
} catch (e) {
  print('Failed to save document: $e');
}
```

Errors are logged with context including:
- Method name where error occurred
- Data that was being processed
- Firebase error codes and messages (if applicable)
- Error type information

## Testing

Use FakeFirebaseFirestore for unit testing:

```dart
class TestUserRepository with CrudRepository {
  @override
  String get collection => 'users';
  
  @override
  bool get forTesting => true;
}

void main() {
  test('saves and fetches user', () async {
    final repo = TestUserRepository();
    
    await repo.saveDocument(data: {
      'id': 'test123',
      'name': 'Test User'
    });
    
    final user = await repo.fetchDocumentById(docId: 'test123');
    expect(user.exists, isTrue);
  });
}
```

## Logging

Enable logging to get detailed information about all operations:

```dart
class UserRepository with CrudRepository {
  @override
  String get collection => 'users';
  
  @override
  bool get enableLogging => true;
  
  @override
  Logger? get logger => Logger();
}
```

Log output includes:
- ⌛ Operation start indicators
- ✅ Operation completion confirmations
- 🔴 Error details with context
- Operation completion times in milliseconds

## Deprecation Notice

The following methods are deprecated in favor of their new names:
- `docById()` → use `fetchDocumentById()` instead
- `add()` → use `saveDocument()` instead
- `fetchAll()` → use `fetchAllDocuments()` instead
- `delete()` → use `deleteDocument()` instead
- `isExist()` → check document existence using `fetchDocumentById()` instead

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## License

This project is licensed under the MIT License – see the LICENSE file for details.
