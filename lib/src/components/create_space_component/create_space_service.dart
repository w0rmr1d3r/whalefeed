import 'dart:async';

import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/model/space.dart';
import 'package:whalefeed/src/model/user.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/db_service.dart';
import 'package:whalefeed/src/services/input_cleaner_service.dart';
import 'package:whalefeed/src/services/json_parser_service.dart';

/// Service from the create space component
class CreateSpaceService {
  final CurrentUserService _currentUser;
  final DBService _db;
  final InputCleanerService _cleaner;
  final JSONParserService _jsonParserService;

  /// Constructor
  CreateSpaceService(
      this._cleaner, this._currentUser, this._db, this._jsonParserService);

  /// Creates a space
  Future<Map> createSpace(Map<String, dynamic> data) async {
    bool submitError = false;
    String spaceName;
    Map parsedData = _jsonParserService.getMapFromJSON(data);

    if (parsedData.isNotEmpty &&
        parsedData.length == 1 &&
        parsedData.containsKey(spacenameKey)) {
      Map spaceNameResult =
          _cleaner.cleanSpaceName((parsedData[spacenameKey]).toString());
      spaceName = spaceNameResult[spacenameKey];
      submitError = !spaceNameResult[successKey] ||
          !(await _db.checkSpaceIsUnique(spaceName));

      if (!submitError) {
        User user = _currentUser.user;
        if (user.subscribedSpaces.length < 50) {
          // TODO : this 50 is a constant
          DateTime creationDate = new DateTime.now();
          Space newSpace = new Space(spaceName, {}, {}, false, creationDate);

          user.createSpace(newSpace, _db);
          await user.subscribeToSpace(newSpace, _db);
          await newSpace.addSubscriber(user, _db);
        }
      } else {
        submitError = true;
      }
    } else {
      submitError = true;
    }

    return {errorKey: submitError, spacenameKey: spaceName};
  }
}
