import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/model/message.dart';
import 'package:whalefeed/src/model/space.dart';
import 'package:whalefeed/src/model/user.dart';
import 'package:whalefeed/src/services/json_parser_service.dart';

/// Service that returns objects given an unparsed JSON
class MapToObjectService {
  final JSONParserService _jsonParser;

  /// Constructor
  MapToObjectService(this._jsonParser);

  /// Returns a message given an parsed JSON
  Message getMessageFromMap(Map parsedJSON) => new Message(
      parsedJSON[contentKey],
      parsedJSON[spacenameKey],
      parsedJSON[usernameKey],
      DateTime.parse(parsedJSON[creationdateKey].toString()),
      parsedJSON[userspaceKey]);

  /// Returns a space given an parsed JSON
  Space getSpaceFromMap(Map parsedJSON) => new Space(
      parsedJSON[nameKey],
      parsedJSON.containsKey(messagesKey)
          ? _jsonParser.getMapFromJSON(parsedJSON[messagesKey])
          : {},
      parsedJSON.containsKey(subscribedKey)
          ? _jsonParser.getMapFromJSON(parsedJSON[subscribedKey])
          : {},
      parsedJSON[officialKey],
      DateTime.parse(parsedJSON[creationdateKey].toString()));

  /// Returns a user given a parsed JSON
  User getUserFromMap(Map parsedJSON) => new User(
      parsedJSON[usernameKey],
      parsedJSON[emailKey],
      parsedJSON[passwordKey],
      DateTime.parse(parsedJSON[registerdateKey].toString()),
      _jsonParser.getMapFromJSON(parsedJSON[followingKey]),
      parsedJSON.containsKey(followedKey)
          ? _jsonParser.getMapFromJSON(parsedJSON[followedKey])
          : {},
      _jsonParser.getMapFromJSON(parsedJSON[subscribedKey]),
      parsedJSON.containsKey(messagesKey)
          ? _jsonParser.getMapFromJSON(parsedJSON[messagesKey])
          : {},
      parsedJSON.containsKey(descriptionKey) ? parsedJSON[descriptionKey] : '',
      parsedJSON.containsKey(photosrcKey)
          ? parsedJSON[photosrcKey].toString()
          : '',
      parsedJSON.containsKey(languageKey) ? parsedJSON[languageKey] : '',
      parsedJSON.containsKey(lastloginKey)
          ? DateTime.parse(parsedJSON[lastloginKey].toString())
          : null);
}
