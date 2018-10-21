import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_toast/dart_toast.dart';

import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/db_service.dart';
import 'package:whalefeed/src/services/input_cleaner_service.dart';
import 'package:whalefeed/src/services/json_parser_service.dart';

/// Service for the settings component
class UserSettingsService {
  final AuthService _auth;
  final CurrentUserService _currentUser;
  final DBService _db;
  final InputCleanerService _cleaner;
  final JSONParserService _jsonParserService;

  /// Constructor
  UserSettingsService(this._auth, this._cleaner, this._currentUser, this._db,
      this._jsonParserService);

  /// Saves a language
  Future<Map<String, bool>> saveLanguage(
      Map unparsedData, List<String> languagesList) async {
    bool languageSaved = false;
    bool languageError = true;
    Map parsedData = _jsonParserService.getMapFromJSON(unparsedData);

    if (parsedData.isNotEmpty &&
        parsedData.length == 1 &&
        parsedData.containsKey(languageKey)) {
      Map languageResult = _cleaner.cleanLanguage(
          (parsedData[languageKey]).toString(), languagesList);
      String newLanguage = languageResult[languageKey];
      languageError = !languageResult[successKey];

      if (!languageError) {
        if (await _db.updateLanguage(newLanguage)) {
          languageSaved = true;
          _currentUser.user.lang = newLanguage;
          new Toast('', 'Feature in progress', position: ToastPos.topCenter);
        } else {
          languageError = true;
        }
      }
    }

    return {successKey: languageSaved, errorKey: languageError};
  }

  /// Saves the email
  Future<Map<String, bool>> saveEmail(Map unparsedData) async {
    bool emailError = true;
    bool emailSaved = false;
    Map parsedData = _jsonParserService.getMapFromJSON(unparsedData);

    if (parsedData.isNotEmpty &&
        parsedData.length == 2 &&
        parsedData.containsKey(currentemailKey) &&
        parsedData.containsKey(newemailKey)) {
      Map newEmailResult =
          _cleaner.cleanEmail((parsedData[newemailKey]).toString());
      String newEmail = newEmailResult[emailKey];
      emailError = !newEmailResult[successKey];

      Map currentEmailResult =
          _cleaner.cleanEmail((parsedData[currentemailKey]).toString());
      String currentEmail = currentEmailResult[emailKey];
      emailError = emailError ||
          !currentEmailResult[successKey] ||
          newEmail == currentEmail;

      if (!emailError) {
        if (_currentUser.email == currentEmail &&
            await _db.checkEmailIsUnique(newEmail)) {
          if (await _db.updateEmail(newEmail)) {
            if (await _auth.updateEmail(newEmail)) {
              emailSaved = true;
              _currentUser.user.email = newEmail;
            } else {
              emailError = true;
              await _db.updateEmail(currentEmail);
            }
          } else {
            emailError = true;
          }
        } else {
          emailError = true;
        }
      }
    }

    return {successKey: emailSaved, errorKey: emailError};
  }

  /// Saves the password
  Future<Map<String, bool>> savePassword(Map unparsedData) async {
    bool passwordError = true;
    bool passwordSaved = false;
    Map parsedData = _jsonParserService.getMapFromJSON(unparsedData);

    if (parsedData.isNotEmpty &&
        parsedData.length == 3 &&
        parsedData.containsKey(currentpasswordKey) &&
        parsedData.containsKey(newpasswordKey) &&
        parsedData.containsKey(newpasswordrepeatKey)) {
      Map currentPasswordResult =
          _cleaner.cleanPassword((parsedData[currentpasswordKey]).toString());
      String currentPassword = currentPasswordResult[passwordKey];
      passwordError = !currentPasswordResult[successKey];

      Map newPasswordResult =
          _cleaner.cleanPassword((parsedData[newpasswordKey]).toString());
      String newPassword = newPasswordResult[passwordKey];
      passwordError = passwordError || !newPasswordResult[successKey];

      Map newPasswordRepeatResult =
          _cleaner.cleanPassword((parsedData[newpasswordrepeatKey]).toString());
      String newPasswordRepeat = newPasswordRepeatResult[passwordKey];
      passwordError = !newPasswordRepeatResult[successKey];

      passwordError = passwordError ||
          currentPassword == newPassword ||
          newPassword != newPasswordRepeat;

      if (!passwordError) {
        currentPassword =
            sha256.convert(utf8.encode(currentPassword)).toString();

        if (currentPassword == _currentUser.user.password) {
          newPassword = sha256.convert(utf8.encode(newPassword)).toString();

          if (await _db.updatePassword(newPassword)) {
            if (await _auth.updatePassword(newPassword)) {
              passwordSaved = true;
              _currentUser.user.password = newPassword;
            } else {
              passwordError = true;
              await _db.updatePassword(currentPassword);
            }
          } else {
            passwordError = true;
          }
        } else {
          passwordError = true;
        }
      }
    }

    return {successKey: passwordSaved, errorKey: passwordError};
  }

  /// Saves the description
  Future<Map<String, bool>> saveDescription(Map unparsedData) async {
    bool descriptionError = true;
    bool descriptionSaved = false;
    Map parsedData = _jsonParserService.getMapFromJSON(unparsedData);

    if (parsedData.isNotEmpty &&
        parsedData.length == 1 &&
        parsedData.containsKey(descriptionKey)) {
      Map descriptionResult =
          _cleaner.cleanDescription((parsedData[descriptionKey]).toString());
      String newDescription = descriptionResult[descriptionKey];
      descriptionError = !descriptionResult[successKey];

      if (!descriptionError) {
        if (await _db.updateDescription(newDescription)) {
          descriptionSaved = true;
          _currentUser.user.description = newDescription;
        } else {
          descriptionError = true;
        }
      }
    }

    return {successKey: descriptionSaved, errorKey: descriptionError};
  }
}
