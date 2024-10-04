import 'dart:developer';

import 'package:firebase_crud/mixin/auth_service.dart';
import 'package:firebase_crud/mixin/crud_repos.dart';
import 'package:firebase_crud/mixin/firestore_read_service.dart';
import 'package:firebase_crud/mixin/firestore_write_service.dart';
import 'package:firebase_crud/mixin/logger_service.dart';
import 'package:logger/logger.dart';

/// Example Repository using all three mixins (Read, Write, and Auth)
class UserRepository with FirestoreReadRepository, FirestoreWriteRepository, AuthRepository {
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

/// Example: Fetch a User by Document ID
void fetchUserById(String userId) async {
  final userRepository = UserRepository();

  try {
    await userRepository.checkAuthenticated();
    final userDocument = await userRepository.fetchDocumentById(docId: userId);
    if (userDocument.exists) {
      final userData = userDocument.data();
      log('User data: $userData');
    } else {
      log('User not found');
    }
  } catch (e) {
    log('Error fetching user: $e');
  }
}

/// Example: Save a New User Document
void saveUser(Map<String, dynamic> userData) async {
  final userRepository = UserRepository();

  try {
    await userRepository.checkAuthenticated();
    await userRepository.saveDocument(data: userData);
    log('User saved successfully');
  } catch (e) {
    log('Error saving user: $e');
  }
}
