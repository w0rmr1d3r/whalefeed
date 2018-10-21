import 'dart:async';

import 'package:firebase/firebase.dart' as fb;

import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/model/message.dart';
import 'package:whalefeed/src/model/space.dart';
import 'package:whalefeed/src/model/user.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/json_parser_service.dart';
import 'package:whalefeed/src/services/map_to_object_service.dart';
import 'package:whalefeed/src/services/object_to_map_service.dart';

/// Service for the database
class DBService {
  final AuthService _auth;
  final JSONParserService _jsonParserService;
  final MapToObjectService _mapToObjectService;
  final ObjectToMapService _objectToMapService;
  final fb.DatabaseReference _usersRef = fb.database().ref(usersKey);
  final fb.DatabaseReference _spacesRef = fb.database().ref(spacesKey);
  final fb.DatabaseReference _messagesRef = fb.database().ref(messagesKey);

  /// Constructor
  DBService(this._auth, this._jsonParserService, this._mapToObjectService,
      this._objectToMapService);

  /// Inits the listeners for the current user
  void initCurrentUserListeners(CurrentUserService _currentUser) {
    _usersRef
        .child(_auth.currentUserID)
        .child(followedKey)
        .onChildAdded
        .listen((fb.QueryEvent event) {
      _currentUser.addFollowerListener(
          event.snapshot.key, event.snapshot.val());
    });

    _usersRef
        .child(_auth.currentUserID)
        .child(followedKey)
        .onChildRemoved
        .listen((fb.QueryEvent event) {
      _currentUser.removeFollowerListener(event.snapshot.key);
    });
  }

  Future<bool> userDoesNotExists(User user) async {
    bool success = false;
    await _usersRef
        .orderByChild(usernameKey)
        .equalTo(user.username)
        .once('value')
        .then((fb.QueryEvent event) {
      success = event.snapshot.val() == null;
    });
    return success;
  }

  /// Creates a new user node in the DB
  void createNewUser(User user, String userID) {
    _usersRef.child(userID).set(_objectToMapService.getMapFromUser(user));
  }

  /// Creates a new space node in the DB
  void createSpace(Space space) {
    _spacesRef.push(_objectToMapService.getMapFromSpace(space));
  }

  /// Creates a new message node in the DB and returns its ID
  Future<String> createNewMessage(Message message) async {
    String messageID =
        _messagesRef.push(_objectToMapService.getMapFromMessage(message)).key;
    return messageID;
  }

  /// Gets a user given a username
  Future<User> getUser(String username) async {
    User userFound;

    await _usersRef
        .orderByChild(usernameKey)
        .equalTo(username)
        .limitToFirst(1)
        .once('value')
        .then((fb.QueryEvent event) {
      Map receivedUser =
          _jsonParserService.getMapFromJSON(event.snapshot.val());
      Map userData = receivedUser[receivedUser.keys.first];

      userFound = _mapToObjectService.getUserFromMap(userData);
    }).catchError((dynamic error, StackTrace stack) {});

    return userFound;
  }

  /// Gets a space given a space name
  Future<Space> getSpace(String spaceName) async {
    Space spaceFound;

    await _spacesRef
        .orderByChild(nameKey)
        .equalTo(spaceName)
        .limitToFirst(1)
        .once('value')
        .then((fb.QueryEvent event) {
      Map receivedSpace =
          _jsonParserService.getMapFromJSON(event.snapshot.val());
      Map spaceData = receivedSpace[receivedSpace.keys.first];

      spaceFound = _mapToObjectService.getSpaceFromMap(spaceData);
    }).catchError((dynamic error, StackTrace stack) {});

    return spaceFound;
  }

  /// Gets the current auth user username
  Future<String> getUsername() async {
    String username;

    await _usersRef
        .orderByKey()
        .equalTo(_auth.currentUserID)
        .limitToFirst(1)
        .once('value')
        .then((fb.QueryEvent event) {
      Map receivedUser =
          _jsonParserService.getMapFromJSON(event.snapshot.val());
      Map userData = receivedUser[receivedUser.keys.first];
      username = userData[usernameKey].toString();
    }).catchError((dynamic error, StackTrace stack) {});

    return username;
  }

  /// Gets the ID given a space name
  Future<String> getSpaceID(String spaceName) async {
    String spaceID;

    await _spacesRef
        .orderByChild(nameKey)
        .equalTo(spaceName)
        .limitToFirst(1)
        .once('value')
        .then((fb.QueryEvent event) {
      Map receivedData =
          _jsonParserService.getMapFromJSON(event.snapshot.val());
      spaceID = receivedData.keys.first;
    });

    return spaceID;
  }

  /// Gets messages for a given user and if given a space
  Future<List<Message>> getMessages(User user, {Space space}) async {
    List<Message> messages = [];
    List<String> followingUsers = [];

    // 1- select followings
    user.following.keys.forEach((String follow) {
      followingUsers.add(follow);
    });

    for (String follow in followingUsers) {
      await _messagesRef
          .orderByChild(space != null ? userspaceKey : usernameKey)
          .equalTo(space != null ? '$follow~${space.name}' : follow)
          .once('value')
          .then((fb.QueryEvent event) {
        Map receivedData =
            _jsonParserService.getMapFromJSON(event.snapshot.val());
        if (receivedData != null) {
          for (Map messageData in receivedData.values) {
            // 3- for each message -> construct object and append
            messages.add(_mapToObjectService.getMessageFromMap(messageData));
          }
        }
      }).catchError((dynamic error, StackTrace stack) {});
    }

    messages.sort((a, b) => b.creationDate.compareTo(a.creationDate));

    return messages.toList();
  }

  /// Gets the messages from a User and a Space
  Future<List<Message>> getUserSpaceMessages(User user, Space space) async {
    List<Message> messages = [];

    await _messagesRef
        .orderByChild(userspaceKey)
        .equalTo('${user.username}~${space.name}')
        .once('value')
        .then((fb.QueryEvent event) {
      Map receivedData =
          _jsonParserService.getMapFromJSON(event.snapshot.val());
      for (Map messageData in receivedData.values) {
        messages.add(_mapToObjectService.getMessageFromMap(messageData));
      }
    }).catchError((dynamic error, StackTrace stack) {});

    messages.sort((a, b) => b.creationDate.compareTo(a.creationDate));

    return messages.toList();
  }

  Future<bool> updateLastLogin(DateTime newLastLogin) async {
    bool success = true;

    await _usersRef
        .child(_auth.currentUserID)
        .child(lastloginKey)
        .set(newLastLogin.toString())
        .catchError((dynamic error, StackTrace stack) {
      success = false;
    });

    return success;
  }

  Future<bool> updateLanguage(String newLanguage) async {
    bool success = true;

    await _usersRef
        .child(_auth.currentUserID)
        .child(languageKey)
        .set(newLanguage)
        .catchError((dynamic error, StackTrace stack) {
      success = false;
    });

    return success;
  }

  Future<bool> updateEmail(String newEmail) async {
    bool success = true;

    await _usersRef
        .child(_auth.currentUserID)
        .child(emailKey)
        .set(newEmail)
        .catchError((dynamic error, StackTrace stack) {
      success = false;
    });

    return success;
  }

  Future<bool> updatePassword(String newPassword) async {
    bool success = true;

    await _usersRef
        .child(_auth.currentUserID)
        .child(passwordKey)
        .set(newPassword)
        .catchError((dynamic error, StackTrace stack) {
      success = false;
    });

    return success;
  }

  Future<bool> updateDescription(String newDescription) async {
    bool success = true;

    await _usersRef
        .child(_auth.currentUserID)
        .child(descriptionKey)
        .set(newDescription)
        .catchError((dynamic error, StackTrace stack) {
      success = false;
    });

    return success;
  }

  /// Checks the email does not exist in the DB
  Future<bool> checkEmailIsUnique(String newEmail) async {
    bool isUnique = false;

    await _usersRef
        .orderByChild(emailKey)
        .equalTo(newEmail)
        .once('value')
        .then((fb.QueryEvent event) {
      isUnique =
          _jsonParserService.getMapFromJSON(event.snapshot.val()) == null;
    }).catchError((dynamic error, StackTrace stack) {});

    return isUnique;
  }

  /// Checks the Spaces does not exist in the DB
  Future<bool> checkSpaceIsUnique(String newSpaceName) async {
    bool isUnique = false;

    await _spacesRef
        .orderByChild(nameKey)
        .equalTo(newSpaceName)
        .once('value')
        .then((fb.QueryEvent event) {
      isUnique =
          _jsonParserService.getMapFromJSON(event.snapshot.val()) == null;
    }).catchError((dynamic error, StackTrace stack) {});

    return isUnique;
  }

  /// The user follows another user by updating its following attr
  Future followUser(User userFollowing) async {
    Map<String, dynamic> currentDBFollowing = {};

    await _usersRef
        .orderByChild(usernameKey)
        .equalTo(userFollowing.username)
        .limitToFirst(1)
        .once('value')
        .then((fb.QueryEvent event) {
      Map receivedUser =
          _jsonParserService.getMapFromJSON(event.snapshot.val());
      Map userData = receivedUser[receivedUser.keys.first];

      currentDBFollowing = userData.containsKey(followingKey)
          ? _jsonParserService.getMapFromJSON(userData[followingKey])
          : currentDBFollowing;
    }).catchError((dynamic error, StackTrace stack) {});

    currentDBFollowing.addAll(userFollowing.following);

    await _usersRef
        .child(_auth.currentUserID)
        .child(followingKey)
        .update(currentDBFollowing)
        .catchError((dynamic error, StackTrace stack) {});
  }

  /// A user becomes followed and updates its followed attr
  Future becomeFollowed(User userBecomingFollowed) async {
    Map<String, dynamic> currentFollowed = {};
    String userBeingFollowedID;

    await _usersRef
        .orderByChild(usernameKey)
        .equalTo(userBecomingFollowed.username)
        .limitToFirst(1)
        .once('value')
        .then((fb.QueryEvent event) {
      Map receivedUser =
          _jsonParserService.getMapFromJSON(event.snapshot.val());
      userBeingFollowedID = receivedUser.keys.first;
      Map userData = receivedUser[receivedUser.keys.first];
      currentFollowed = userData.containsKey(followedKey)
          ? _jsonParserService.getMapFromJSON(userData[followedKey])
          : currentFollowed;
    }).catchError((dynamic error, StackTrace stack) {});

    currentFollowed.addAll(userBecomingFollowed.followed);

    await _usersRef
        .child(userBeingFollowedID)
        .child(followedKey)
        .update(currentFollowed)
        .catchError((dynamic error, StackTrace stack) {});
  }

  /// Adds a space to a user
  Future addSpaceToUser(User user, Space space) async {
    Map<String, dynamic> currentSubs = {};

    await _usersRef
        .orderByChild(usernameKey)
        .equalTo(user.username)
        .limitToFirst(1)
        .once('value')
        .then((fb.QueryEvent event) {
      Map receivedUser =
          _jsonParserService.getMapFromJSON(event.snapshot.val());
      Map userData = receivedUser[receivedUser.keys.first];
      currentSubs = userData.containsKey(subscribedKey)
          ? _jsonParserService.getMapFromJSON(userData[subscribedKey])
          : currentSubs;
    }).catchError((dynamic error, StackTrace stack) {});

    currentSubs.addAll(user.subscribedSpaces);

    await _usersRef
        .child(_auth.currentUserID)
        .child(subscribedKey)
        .update(currentSubs)
        .catchError((dynamic error, StackTrace stack) {});
  }

  /// Adds a user to a space
  Future addUserToSpace(User user, Space space) async {
    Map<String, dynamic> currentSubs = {};
    String spaceID;

    await _spacesRef
        .orderByChild(nameKey)
        .equalTo(space.name)
        .limitToFirst(1)
        .once('value')
        .then((fb.QueryEvent event) {
      Map receivedSpace =
          _jsonParserService.getMapFromJSON(event.snapshot.val());
      spaceID = receivedSpace.keys.first;
      Map spaceData = receivedSpace[spaceID];

      currentSubs = spaceData.containsKey(subscribedKey)
          ? _jsonParserService.getMapFromJSON(spaceData[subscribedKey])
          : currentSubs;
    }).catchError((dynamic error, StackTrace stack) {});

    currentSubs.addAll(space.subscribed);

    await _spacesRef
        .child(spaceID)
        .child(subscribedKey)
        .update(currentSubs)
        .catchError((dynamic error, StackTrace stack) {});
  }

  /// Adds a message to a user
  Future addMessageToUser(User user, Message message, String messageID) async {
    Map<String, dynamic> currentMessages = {};

    await _usersRef
        .orderByChild(usernameKey)
        .equalTo(user.username)
        .limitToFirst(1)
        .once('value')
        .then((fb.QueryEvent event) {
      Map receivedUser =
          _jsonParserService.getMapFromJSON(event.snapshot.val());
      Map userData = receivedUser[receivedUser.keys.first];
      currentMessages = userData.containsKey(messagesKey)
          ? _jsonParserService.getMapFromJSON(userData[messagesKey])
          : currentMessages;
    }).catchError((dynamic error, StackTrace stack) {});

    currentMessages.addAll(user.messages);

    await _usersRef
        .child(_auth.currentUserID)
        .child(messagesKey)
        .update(currentMessages)
        .catchError((dynamic error, StackTrace stack) {});
  }

  /// Adds a message to a space
  Future addMessageToSpace(
      Space space, Message message, String messageID) async {
    Map<String, dynamic> currentMessages = {};
    String spaceID;

    await _spacesRef
        .orderByChild(nameKey)
        .equalTo(space.name)
        .limitToFirst(1)
        .once('value')
        .then((fb.QueryEvent event) {
      Map receivedSpace =
          _jsonParserService.getMapFromJSON(event.snapshot.val());
      spaceID = receivedSpace.keys.first;
      Map spaceData = receivedSpace[spaceID];

      currentMessages = spaceData.containsKey(messagesKey)
          ? _jsonParserService.getMapFromJSON(spaceData[messagesKey])
          : currentMessages;
    }).catchError((dynamic error, StackTrace stack) {});

    currentMessages.addAll(space.messages);

    await _spacesRef
        .child(spaceID)
        .child(messagesKey)
        .update(currentMessages)
        .catchError((dynamic error, StackTrace stack) {});
  }

  Future removeUserFromSpace(User user, Space space) async {
    await _spacesRef
        .child(await getSpaceID(space.name))
        .child(subscribedKey)
        .set(space.subscribed)
        .catchError((dynamic error, StackTrace stack) {});
  }

  Future removeSpaceFromUser(User user, Space space) async {
    await _usersRef
        .child(_auth.currentUserID)
        .child(subscribedKey)
        .set(user.subscribedSpaces)
        .catchError((dynamic error, StackTrace stack) {});
  }

  /// The user unfollows another user
  Future unfollowUser(User userWhoUnfollows) async {
    await _usersRef
        .child(_auth.currentUserID)
        .child(followingKey)
        .set(userWhoUnfollows.following)
        .catchError((dynamic error, StackTrace stack) {});
  }

  /// A user becomes unfollowed by another user
  Future becomeUnfollowed(User userToUpdate) async {
    String userToUpdateID;

    await _usersRef
        .orderByChild(usernameKey)
        .equalTo(userToUpdate.username)
        .limitToFirst(1)
        .once('value')
        .then((fb.QueryEvent event) {
      Map receivedUser =
          _jsonParserService.getMapFromJSON(event.snapshot.val());
      userToUpdateID = receivedUser.keys.first;
    }).catchError((dynamic error, StackTrace stack) {});

    await _usersRef
        .child(userToUpdateID)
        .child(followedKey)
        .set(userToUpdate.followed)
        .catchError((dynamic error, StackTrace stack) {});
  }

  /// Search for a user and a space
  Future<Map> search(String inputSearch) async {
    String username, spacename;

    await _usersRef
        .orderByChild(usernameKey)
        .equalTo(inputSearch)
        .limitToFirst(1)
        .once('value')
        .then((fb.QueryEvent event) {
      Map receivedData =
          _jsonParserService.getMapFromJSON(event.snapshot.val());
      Map userData = receivedData[receivedData.keys.first];
      username = userData[usernameKey];
    }).catchError((dynamic error, StackTrace stack) {});

    await _spacesRef
        .orderByChild(nameKey)
        .equalTo(inputSearch)
        .limitToFirst(1)
        .once('value')
        .then((fb.QueryEvent event) {
      Map receivedData =
          _jsonParserService.getMapFromJSON(event.snapshot.val());
      Map spaceData = receivedData[receivedData.keys.first];
      spacename = spaceData[nameKey];
    }).catchError((dynamic error, StackTrace stack) {});

    return {usernameKey: username, spacenameKey: spacename};
  }
}
