import 'dart:async';

import 'package:whalefeed/src/model/user.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/db_service.dart';

/// Service to perform the follow and unfollow actions
class FollowService {
  final DBService _db;
  final CurrentUserService _currentUser;

  /// Constructor
  FollowService(this._currentUser, this._db);

  /// Follows the username selected
  Future followUser(String usernameToFollow) async {
    User userToBecomeFollowed = await _db.getUser(usernameToFollow);
    await followByUser(userToBecomeFollowed);
  }

  /// Follows the user
  Future followByUser(User userToBecomeFollowed) async {
    DateTime followDate =
        await _currentUser.user.followUser(userToBecomeFollowed, _db);
    userToBecomeFollowed.becomeFollowed(_currentUser.user, followDate, _db);
  }

  /// Unfollows the username selected
  Future unfollowUser(String usernameToUnfollow) async {
    User userToUnfollow = await _db.getUser(usernameToUnfollow);
    await unfollowByUser(userToUnfollow);
  }

  /// Unfollows the user
  Future unfollowByUser(User userToUnfollow) async {
    _currentUser.user.unfollowUser(userToUnfollow, _db);
    userToUnfollow.becomeUnfollowedBy(_currentUser.user, _db);
  }
}
