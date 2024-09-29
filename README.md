# Firebase CRUD with Logging - Dart Package

## Overview

This package provides a reusable mixin to handle CRUD (Create, Read, Update, Delete) operations for Firestore collections. It integrates logging functionality via the `Logger` package, allowing developers to log operations and errors for better tracking and debugging. The package is designed with flexibility, allowing the use of different Firestore collections, and provides support for optional testing environments.

## Features

- **CRUD Operations**: Easily perform Firestore document operations such as fetching, saving, deleting, and retrieving all documents from a collection.
- **Logging Support**: Log actions, errors, and completion times using the `Logger` package for detailed operation insights.
- **Reusable Mixin**: The `CrudRepository` mixin allows for easy integration into any class needing Firestore CRUD functionality.
- **Firestore Service Abstraction**: Decoupled Firestore operations through `FirestoreService` and `FirestoreServiceImpl`, which handle the core Firestore interaction logic.
- **Testing Support**: Simplify Firestore operations in test environments using the `forTesting` flag.

## Getting Started

### Installation

Add the following dependencies to your `pubspec.yaml` file:

```yaml
dependencies:
  cloud_firestore: ^3.0.0
  logger: ^1.0.0
  firebase_crud: ^1.0.0
```

### Usage

1. **Import the necessary libraries:**

```dart
import 'package:firebase_crud/mixin/crud_repos.dart';
import 'package:logger/logger.dart';
```

2. **Create a class that implements the CRUD mixin:**

```dart
class InitDataSources with CrudRepository {
  @override
  String collection = 'buyer';
  
  @override
  bool forTesting = true;

  @override
  FirestoreService get firestoreService => FirestoreServiceImpl();

  @override
  LoggerService? get loggerService => LoggerServiceImpl(Logger(), true);
}
```

3. **Perform CRUD operations:**

```dart
final dataSource = InitDataSources();

// Fetch a document by ID
final doc = await dataSource.fetchDocumentById(docId: '12345');

// Save a new document
await dataSource.saveDocument(data: {
  'name': 'John Doe',
  'email': 'johndoe@example.com'
});

// Fetch all documents
final documents = await dataSource.fetchAllDocuments();

// Delete a document by ID
await dataSource.deleteDocument(documentId: '12345');
```

### Customization

- **Firestore Collection**: The collection to be used is set by overriding the `collection` property.
- **Testing Mode**: The `forTesting` flag can be set to `true` to use a test environment for Firestore operations.
- **Logger Service**: You can choose whether to enable logging and customize the log messages by overriding the `loggerService`.

## Logging Features

The package provides three types of logging:
1. **Standard Logs**: Informational logs about operations such as fetching or saving documents.
2. **Error Logs**: Logs detailing any issues that occur during CRUD operations.
3. **Completion Logs**: Logs that track the time taken to complete operations.

### Example:

```dart
loggerService?.log("⌛ Fetching document in progress");
loggerService?.logError("Error fetching document", e.toString());
loggerService?.logCompletionTime(startTime, 'Fetching document');
```

## FirestoreService

This package abstracts the Firestore interactions via the `FirestoreService` interface and its implementation `FirestoreServiceImpl`. The core methods include:
- `getCollectionReference()`: Retrieves the collection reference.
- `fetchDocumentById()`: Fetches a document by its ID.
- `saveDocument()`: Saves a new or existing document.
- `fetchAllDocuments()`: Retrieves all documents in a collection.
- `deleteDocument()`: Deletes a document by its ID.

## LoggerService

The `LoggerService` provides logging functionality using the `Logger` package. The `LoggerServiceImpl` logs information conditionally, based on the `_enableLogging` flag.

## Contributing

Feel free to open issues or submit pull requests for any improvements or new features. We encourage collaboration!

## License

This package is available under the MIT License.