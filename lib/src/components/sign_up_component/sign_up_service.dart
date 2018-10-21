import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/model/space.dart';
import 'package:whalefeed/src/model/user.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/db_service.dart';
import 'package:whalefeed/src/services/input_cleaner_service.dart';
import 'package:whalefeed/src/services/json_parser_service.dart';

/// Service to perform the first actions such as autofollowing and
/// following the first official spaces
class SignUpService {
  final List<Space> _firstSpaces = [
    new Space(
        'Advice', {}, {}, true, DateTime.parse('2018-03-18 17:30:00.000')),
    new Space('Books', {}, {}, true, DateTime.parse('2018-03-18 17:30:00.000')),
    new Space('CE3', {}, {}, true, DateTime.parse('2018-03-18 17:30:00.000')),
    new Space(
        'Dank Memes', {}, {}, true, DateTime.parse('2018-03-18 17:30:00.000')),
    new Space('Earth Sciences', {}, {}, true,
        DateTime.parse('2018-03-18 17:30:00.000')),
    new Space(
        'Meetups', {}, {}, true, DateTime.parse('2018-03-18 17:30:00.000')),
    new Space('Memes', {}, {}, true, DateTime.parse('2018-03-18 17:30:00.000')),
    new Space(
        'Parties', {}, {}, true, DateTime.parse('2018-03-18 17:30:00.000')),
    new Space(
        'Random', {}, {}, true, DateTime.parse('2018-03-18 17:30:00.000')),
    new Space(
        'Science', {}, {}, true, DateTime.parse('2018-03-18 17:30:00.000')),
    new Space(
        'Teachers', {}, {}, true, DateTime.parse('2018-03-18 17:30:00.000')),
    new Space(
        'Technology', {}, {}, true, DateTime.parse('2018-03-18 17:30:00.000')),
    new Space(
        'TecnoUAB', {}, {}, true, DateTime.parse('2018-03-18 17:30:00.000')),
    new Space('UAB', {}, {}, true, DateTime.parse('2018-03-18 17:30:00.000'))
  ];

  final AuthService _auth;
  final DBService _db;
  final InputCleanerService _cleaner;
  final JSONParserService _jsonParserService;

  /// Constructor
  SignUpService(this._auth, this._cleaner, this._db, this._jsonParserService);

  /// The [user] follows itself
  Future autoFollow(User user) async {
    await user.followUser(user, _db);
  }

  /// The [user] subscribes to the first official spaces
  Future firstSpaces(User user) async {
    for (Space space in _firstSpaces) {
      await user.subscribeToSpace(space, _db);
      await space.addSubscriber(user, _db);
    }
  }

  /// Performs the signup
  Future<Map<String, dynamic>> performSignUp(
      Map<String, dynamic> unparsedData) async {
    bool submitError = false;
    bool submitCorrect = false;
    String errorMessage = 'Ups! An error has occurred :(';

    Map parsedData = _jsonParserService.getMapFromJSON(unparsedData);

    if (parsedData.isNotEmpty &&
        parsedData.length == 4 &&
        parsedData.containsKey(usernameKey) &&
        parsedData.containsKey(emailKey) &&
        parsedData.containsKey(passwordKey) &&
        parsedData.containsKey(passwordrepeatKey)) {
      // clean username
      Map usernameResult =
          _cleaner.cleanUsername((parsedData[usernameKey]).toString());
      String username = usernameResult[usernameKey];
      if (!usernameResult[successKey]) {
        submitError = true;
        errorMessage = 'Invalid username';
      }

      // clean email
      Map emailResult = _cleaner.cleanEmail((parsedData[emailKey]).toString());
      String email = emailResult[emailKey];
      if (!emailResult[successKey]) {
        submitError = true;
        errorMessage = 'Invalid email';
      }

      // clean password
      Map passwordResult =
          _cleaner.cleanPassword((parsedData[passwordKey]).toString());
      String password = passwordResult[passwordKey];
      if (!passwordResult[successKey]) {
        submitError = true;
        errorMessage = 'Invalid password';
      }

      // clean passwordrepeat
      Map passwordRepeatResult =
          _cleaner.cleanPassword((parsedData[passwordrepeatKey]).toString());
      String passwordrepeat = passwordRepeatResult[passwordKey];
      if (!passwordRepeatResult[successKey]) {
        submitError = true;
        errorMessage = 'Repeat the same password please';
      }

      // check both password
      if (password != passwordrepeat) {
        submitError = true;
        errorMessage = 'Repeat the same password please';
      }

      if (!submitError) {
        // correct data for user
        password = sha256.convert(utf8.encode(password)).toString();
        DateTime registerDate = new DateTime.now();

        // create user object
        User userToSignUp =
            new User(username, email, password, registerDate, {}, {}, {}, {});

        // create user
        if (await _auth.createNewUser(
            userToSignUp.email, userToSignUp.password)) {
          if (await _auth.signIn(userToSignUp.email, userToSignUp.password)) {
            if (await _db.userDoesNotExists(userToSignUp)) {
              _db.createNewUser(userToSignUp, _auth.currentUserID);
              submitCorrect = true;
              await firstSpaces(userToSignUp);
              await autoFollow(userToSignUp);
            } else {
              await _auth.deleteMyself(
                  userToSignUp.email, userToSignUp.password);
            }
            await _auth.signOut();
          }
        } else {
          submitError = true;
          errorMessage = 'Invalid data';
        }
      }
    } else {
      submitError = true;
      errorMessage = 'Invalid data';
    }

    return {
      successKey: submitCorrect,
      errorKey: submitError,
      messageKey: errorMessage
    };
  }
}
