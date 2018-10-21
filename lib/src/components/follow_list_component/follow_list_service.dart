import 'dart:async';

import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/services/direction_service.dart';
import 'package:whalefeed/src/services/follow_service.dart';

/// Service from follow list component
class FollowListService {
  final DirectionService _direction;
  final FollowService _followService;

  /// Constructor
  FollowListService(this._direction, this._followService);

  /// Performs the action to follow, unfollow or go to the user profile
  Future performAction(String type, String usernameClicked) async {
    switch (type) {
      case followingKey:
        // We are following the user and will unfollow it
        await _followService.unfollowUser(usernameClicked);
        break;
      case followedKey:
        // We are not following the user and will follow it
        await _followService.followUser(usernameClicked);
        break;
      case selfKey:
        // We see ourselves and go to our profile
        _direction.goToUserProfile(usernameClicked);
        break;
      default:
        break;
    }
  }
}
