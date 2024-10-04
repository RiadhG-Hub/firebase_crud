# Firebase CRUD with Logging - Dart Package

#This package provides a set of reusable mixins for performing Firestore operations and authentication checks in a clean, modular way. The mixins are designed to follow the SOLID principles, giving developers the flexibility to choose only the functionality they need.

Features
Firestore Read Operations: Fetch individual documents or retrieve all documents from a collection.
Firestore Write Operations: Save or delete documents within a Firestore collection.
Authentication: Check if a user is authenticated before performing operations.
Logging: Optional logging of operations, errors, and completion times for better visibility.
Installation
Add the following to your pubspec.yaml:

yaml
Copy code
dependencies:
cloud_firestore: ^4.1.0
logger: ^1.2.0
Usage
1. Firestore Read Operations
   The FirestoreReadRepository mixin provides read operations for fetching a document by ID and fetching all documents from a collection.

Example
dart
Copy code
import 'package:your_package/firestore_mixin.dart';

class UserReadRepository with FirestoreReadRepository {
@override
String get collection => 'users';

@override
FirestoreReadService get firestoreReadService => FirestoreServiceImpl();

@override
LoggerService? get loggerService => LoggerServiceImpl(Logger(), true);
}

void fetchUserById(String userId) async {
final userRepository = UserReadRepository();

try {
final userDocument = await userRepository.fetchDocumentById(docId: userId);
if (userDocument.exists) {
final userData = userDocument.data();
print('User data: $userData');
} else {
print('User not found');
}
} catch (e) {
print('Error fetching user: $e');
}
}
2. Firestore Write Operations
   The FirestoreWriteRepository mixin provides write operations to save and delete documents in a Firestore collection.

Example
dart
Copy code
class UserWriteRepository with FirestoreWriteRepository {
@override
String get collection => 'users';

@override
FirestoreWriteService get firestoreWriteService => FirestoreWriteServiceImpl();

@override
LoggerService? get loggerService => LoggerServiceImpl(Logger(), true);
}

void saveUser(Map<String, dynamic> userData) async {
final userRepository = UserWriteRepository();

try {
await userRepository.saveDocument(data: userData);
print('User saved successfully');
} catch (e) {
print('Error saving user: $e');
}
}
3. Authentication
   The AuthRepository mixin provides an isAuthenticated check using the AuthService abstraction. This can be combined with other mixins to ensure that only authenticated users can perform certain operations.

Example
dart
Copy code
class AuthenticatedUserRepository with FirestoreReadRepository, FirestoreWriteRepository, AuthRepository {
@override
String get collection => 'users';

@override
FirestoreReadService get firestoreReadService => FirestoreServiceImpl();

@override
FirestoreWriteService get firestoreWriteService => FirestoreWriteServiceImpl();

@override
AuthService get authService => FirebaseAuthService();

@override
LoggerService? get loggerService => LoggerServiceImpl(Logger(), true);
}

void fetchUserIfAuthenticated(String userId) async {
final userRepository = AuthenticatedUserRepository();

try {
await userRepository.checkAuthenticated();
final userDocument = await userRepository.fetchDocumentById(docId: userId);
if (userDocument.exists) {
final userData = userDocument.data();
print('User data: $userData');
} else {
print('User not found');
}
} catch (e) {
print('Error: $e');
}
}
4. Combining Read, Write, and Auth
   If you want to combine both read and write operations with authentication, you can create a repository that includes both FirestoreReadRepository, FirestoreWriteRepository, and AuthRepository.

Example
dart
Copy code
class FullUserRepository with FirestoreReadRepository, FirestoreWriteRepository, AuthRepository {
@override
String get collection => 'users';

@override
FirestoreReadService get firestoreReadService => FirestoreServiceImpl();

@override
FirestoreWriteService get firestoreWriteService => FirestoreWriteServiceImpl();

@override
AuthService get authService => FirebaseAuthService();

@override
LoggerService? get loggerService => LoggerServiceImpl(Logger(), true);
}
Logging
By providing a LoggerService, you can enable logging for any operation. You can log messages, errors, and completion times for operations like fetching or saving documents.

Example
dart
Copy code
final loggerService = LoggerServiceImpl(Logger(), true); // Enable logging
final userRepository = FullUserRepository();

userRepository.loggerService?.log('Fetching all users...');
Classes and Mixins
Firestore Read Operations
FirestoreReadService: Abstract class for read operations.
FirestoreReadRepository: Mixin for fetching documents from Firestore.
Firestore Write Operations
FirestoreWriteService: Abstract class for write operations.
FirestoreWriteRepository: Mixin for saving and deleting documents.
Authentication
AuthService: Abstract class for authentication.
AuthRepository: Mixin for checking authentication.
Logging
LoggerService: Abstract class for logging operations.
Conclusion
This package offers a modular, reusable solution for handling Firestore operations and authentication in Dart and Flutter applications. By using mixins, developers can cleanly separate concerns and only include the functionality they need.

Feel free to modify and extend the code according to your project requirements.