import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/model/message.dart';
import 'package:whalefeed/src/model/space.dart';
import 'package:whalefeed/src/model/user.dart';

/// Returns a Map from a given Object
class ObjectToMapService {
  /// Returns a Map from a given Message
  Map getMapFromMessage(Message message) => {
        contentKey: message.content,
        creationdateKey: message.creationDate.toString(),
        spacenameKey: message.spaceName,
        usernameKey: message.username,
        userspaceKey: message.userspace
      };

  /// Returns a Map from a given Space
  Map getMapFromSpace(Space space) => {
        creationdateKey: space.creationDate.toString(),
        nameKey: space.name,
        messagesKey: space.messages,
        officialKey: space.official,
        subscribedKey: space.subscribed,
      };

  /// Returns a Map from a given User
  Map getMapFromUser(User user) => {
        descriptionKey: user.description,
        emailKey: user.email,
        followingKey: user.following,
        followedKey: user.followed,
        languageKey: user.lang,
        lastloginKey: user.lastLogin.toString(),
        messagesKey: user.messages,
        passwordKey: user.password,
        photosrcKey: user.photosrc,
        registerdateKey: user.registerDate.toString(),
        subscribedKey: user.subscribedSpaces,
        usernameKey: user.username
      };
}
