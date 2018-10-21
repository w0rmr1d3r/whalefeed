import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/db_service.dart';
import 'package:whalefeed/src/services/input_cleaner_service.dart';
import 'package:whalefeed/src/services/json_parser_service.dart';

/// Service for the sign in behaviour
class SignInService {
  final AuthService _auth;
  final CurrentUserService _currentUser;
  final DBService _db;
  final InputCleanerService _cleaner;
  final JSONParserService _jsonParserService;

  /// Constructor
  SignInService(this._auth, this._cleaner, this._currentUser, this._db,
      this._jsonParserService);

  /// Performs the on submit method
  Future<bool> performOnSubmit(Map<String, dynamic> unparsedData) async {
    Map parsedData = _jsonParserService.getMapFromJSON(unparsedData);
    bool submitError = false;
    if (parsedData.isNotEmpty &&
        parsedData.length == 3 &&
        parsedData.containsKey(emailKey) &&
        parsedData.containsKey(passwordKey) &&
        parsedData.containsKey(keepsessionKey)) {
      Map emailResult = _cleaner.cleanEmail((parsedData[emailKey]).toString());
      String email = emailResult[emailKey];
      submitError = !emailResult[successKey];

      Map passwordResult =
          _cleaner.cleanPassword((parsedData[passwordKey]).toString());
      String password = passwordResult[passwordKey];
      submitError = submitError || !passwordResult[successKey];

      if (!submitError) {
        password = sha256.convert(utf8.encode(password)).toString();

        if (await _auth.signIn(email, password)) {
          await _auth.setPersistence(
              (parsedData[keepsessionKey].toString() != 'false' &&
                      _cleaner.isValid(parsedData[keepsessionKey].toString()))
                  ? AuthService.local
                  : AuthService.none);
        } else {
          submitError = true;
        }
      }
    } else {
      submitError = true;
    }

    return submitError;
  }

  /// Inits the current user service
  Future initCurrentUser() async {
    _currentUser.init = await _db.getUser(await _db.getUsername());
  }

  /// Inits the listeners on the DB for the current user
  void initCurrentUserListeners() {
    _db.initCurrentUserListeners(_currentUser);
  }

  /// Updates the last login for the current user
  void updateLastLogin() {
    _currentUser.updateLastLogin();
  }
}
