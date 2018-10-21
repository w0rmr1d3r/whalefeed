import 'dart:async';

import 'package:firebase/firebase.dart' as fb;

/// Service to connect with Firebase Authentication
class AuthService {
  static final String session = fb.Persistence.SESSION;
  static final String local = fb.Persistence.LOCAL;
  static final String none = fb.Persistence.NONE;
  final fb.Auth _auth = fb.auth();

  fb.User get currentUser => _auth.currentUser;
  String get currentUserID => _auth.currentUser.uid;
  fb.Auth get fbAuth => _auth;

  Future<bool> signIn(String userEmail, String userPassword) async {
    bool signIn = true;
    await _auth
        .signInWithEmailAndPassword(userEmail, userPassword)
        .catchError((dynamic error, StackTrace stack) {
      signIn = false;
    });
    return signIn;
  }

  Future<bool> setPersistence(String type) async {
    bool success = true;
    await _auth
        .setPersistence(type)
        .catchError((dynamic error, StackTrace stack) {
      success = false;
    });
    return success;
  }

  Future signOut() async {
    await _auth.signOut().catchError((dynamic error, StackTrace stack) {});
  }

  Future<bool> createNewUser(String userEmail, String userPassword) async {
    bool success = true;
    await _auth
        .createUserWithEmailAndPassword(userEmail, userPassword)
        .catchError((dynamic error, StackTrace stack) {
      success = false;
    });
    return success;
  }

  Future<bool> deleteMyself(String userEmail, String userPassword) async {
    bool success = true;
    await currentUser.delete().catchError((dynamic error, StackTrace stack) {
      success = false;
    });
    return success;
  }

  Future<bool> updateEmail(String newEmail) async {
    bool success = true;
    await _auth.currentUser
        .updateEmail(newEmail)
        .catchError((dynamic error, StackTrace stack) {
      success = false;
    });
    return success;
  }

  Future<bool> updatePassword(String newPassword) async {
    bool success = true;
    await _auth.currentUser
        .updatePassword(newPassword)
        .catchError((dynamic error, StackTrace stack) {
      success = false;
    });
    return success;
  }
}
