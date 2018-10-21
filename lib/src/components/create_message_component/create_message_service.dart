import 'dart:async';

import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/model/message.dart';
import 'package:whalefeed/src/model/space.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/db_service.dart';
import 'package:whalefeed/src/services/input_cleaner_service.dart';
import 'package:whalefeed/src/services/json_parser_service.dart';

/// Service from the create message component
class CreateMessageService {
  final CurrentUserService _currentUser;
  final DBService _db;
  final InputCleanerService _cleaner;
  final JSONParserService _jsonParserService;

  /// Constructor
  CreateMessageService(
      this._cleaner, this._currentUser, this._db, this._jsonParserService);

  /// Creates a message
  Future<Map> createMessage(Map<String, dynamic> data, List<String> userSpaces,
      String username) async {
    bool messageCreationError = false;
    String selectedSpace = '';
    Map parsedData = _jsonParserService.getMapFromJSON(data);

    if (parsedData.isNotEmpty &&
        parsedData.length == 2 &&
        parsedData.containsKey(messageKey) &&
        parsedData.containsKey(spaceselectKey)) {
      selectedSpace = (parsedData[spaceselectKey]).toString();

      Map messageResult =
          _cleaner.cleanMessageContent((parsedData[messageKey]).toString());
      String messageContent = messageResult[messageKey];
      messageCreationError =
          !userSpaces.contains(selectedSpace) || !messageResult[successKey];

      if (_cleaner.isValid(selectedSpace) && !messageCreationError) {
        String userSpace = '$username~$selectedSpace';
        DateTime creationDate = new DateTime.now();
        Message message = new Message(
            messageContent, selectedSpace, username, creationDate, userSpace);
        Space space = await _db.getSpace(message.spaceName);
        String messageID = await _db.createNewMessage(message);

        await _currentUser.user.createMessage(message, messageID, _db);
        await space.addMessage(message, messageID, _db);
      } else {
        messageCreationError = true;
      }
    } else {
      messageCreationError = true;
    }

    return {errorKey: messageCreationError, spacenameKey: selectedSpace};
  }
}
