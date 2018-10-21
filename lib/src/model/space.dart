import 'dart:async';

import 'package:whalefeed/src/model/message.dart';
import 'package:whalefeed/src/model/user.dart';
import 'package:whalefeed/src/services/db_service.dart';

/// Space to classify messages and content
class Space {
  String _name;
  Map<String, dynamic> _subscribed, _messages;
  bool _official;
  DateTime _creationDate;

  /// Constructor
  Space(this._name, this._messages, this._subscribed, this._official,
      this._creationDate);

  /// Gets the space name
  String get name => _name;

  /// Gets a map with this space messages
  Map<String, dynamic> get messages => _messages;

  /// Gets a map with all users subscribed to this space
  Map<String, dynamic> get subscribed => _subscribed;

  /// Gets if is official or not
  bool get official => _official;

  /// Gets the creation date of this space
  DateTime get creationDate => _creationDate;

  /// Adds a message to this space and sends it to the DB
  Future addMessage(Message message, String messageID, DBService db) async {
    if (!_messages.containsKey(messageID)) {
      _messages.addAll({messageID: message.creationDate.toString()});
      await db.addMessageToSpace(this, message, messageID);
    }
  }

  /// Adds a user to this space as a subscriber and sends it to the DB
  Future addSubscriber(User user, DBService db) async {
    if (!_subscribed.containsKey(user.username)) {
      DateTime subscriptionDate = new DateTime.now();
      _subscribed.addAll({user.username: subscriptionDate.toString()});
      await db.addUserToSpace(user, this);
    }
  }

  /// Removes a user from the subscribed and sends it to the DB
  void unsubscribeUser(User user, DBService db) {
    if (_subscribed.containsKey(user.username)) {
      _subscribed.remove(user.username);
      db.removeUserFromSpace(user, this);
    }
  }

  @override
  String toString() => 'Space: $_name';
}
