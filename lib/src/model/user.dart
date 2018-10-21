import 'dart:async';

import 'package:whalefeed/src/model/message.dart';
import 'package:whalefeed/src/model/space.dart';
import 'package:whalefeed/src/services/db_service.dart';

/// User
class User {
  /// User data
  String _username, email, password, description, _photosrc, lang;
  DateTime _registerDate, _lastLogin;
  Map<String, dynamic> _subscribedSpaces, _following, _followed, _messages;

  /// Constructor
  User(this._username, this.email, this.password, this._registerDate,
      this._following, this._followed, this._subscribedSpaces, this._messages,
      [this.description, this._photosrc, this.lang, this._lastLogin]);

  /// Username of the user
  String get username => _username;

  /// Photo SRC of the user
  String get photosrc => _photosrc;

  /// Register date of the user
  DateTime get registerDate => _registerDate;

  /// Last login of the user
  DateTime get lastLogin => _lastLogin;

  /// Map of users this user follows
  Map<String, dynamic> get following => _following;

  /// Map of users whi follow this user
  Map<String, dynamic> get followed => _followed;

  /// Map of subscribed spaces
  Map<String, dynamic> get subscribedSpaces => _subscribedSpaces;

  /// Map of messages cerated
  Map<String, dynamic> get messages => _messages;

  /// Follows another user and sends it to the DB
  Future<DateTime> followUser(User userToFollow, DBService db) async {
    if (!_following.containsKey(userToFollow.username)) {
      DateTime followDate = new DateTime.now();
      _following.addAll({userToFollow.username: followDate.toString()});
      await db.followUser(this);
      return followDate;
    }
    return null;
  }

  /// Become followed by another user and sends it to the DB
  void becomeFollowed(User userFollowedBy, DateTime followDate, DBService db) {
    if (userFollowedBy.username != _username &&
        !_followed.containsKey(userFollowedBy.username)) {
      _followed.addAll({userFollowedBy.username: followDate.toString()});
      db.becomeFollowed(this);
    }
  }

  /// Stop following a user and sends it to the DB
  void unfollowUser(User userToUnfollow, DBService db) {
    if (userToUnfollow.username != _username &&
        _following.containsKey(userToUnfollow.username)) {
      _following.remove(userToUnfollow.username);
      db.unfollowUser(this);
    }
  }

  /// Stop being followed by another user and sends it to the DB
  void becomeUnfollowedBy(User userWhoUnfollows, DBService db) {
    if (userWhoUnfollows.username != _username &&
        _followed.containsKey(userWhoUnfollows.username)) {
      _followed.remove(userWhoUnfollows.username);
      db.becomeUnfollowed(this);
    }
  }

  /// Creates a Space and sends it to the DB
  void createSpace(Space space, DBService db) {
    db.createSpace(space);
  }

  /// Subscribes to a Space
  Future subscribeToSpace(Space space, DBService db) async {
    if (_subscribedSpaces.length < 50 &&
        !_subscribedSpaces.containsKey(space.name)) {
      DateTime subscribedDate = new DateTime.now();
      _subscribedSpaces.addAll({space.name: subscribedDate.toString()});
      await db.addSpaceToUser(this, space);
    }
  }

  /// Unsubscribe from a space
  void unsubscribeFromSpace(Space space, DBService db) {
    if (_subscribedSpaces.length > 1 &&
        _subscribedSpaces.containsKey(space.name)) {
      _subscribedSpaces.remove(space.name);
      db.removeSpaceFromUser(this, space);
    }
  }

  /// Creates a message
  Future createMessage(Message message, String messageID, DBService db) async {
    if (!_messages.containsKey(messageID)) {
      _messages.addAll({messageID: message.spaceName});
      await db.addMessageToUser(this, message, messageID);
    }
  }

  /// TODO : issue #42
  void deleteMessage(Message message) {}

  @override
  String toString() => 'User: $username. Email: $email';
}
