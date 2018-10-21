import 'dart:async';

import 'package:whalefeed/src/model/user.dart';
import 'package:whalefeed/src/services/follow_service.dart';

/// Service for the user profile component
class UserProfileService {
  final FollowService _followService;

  /// Constructor
  UserProfileService(this._followService);

  /// currentUser follows [user]
  Future follow(User user) async {
    await _followService.followUser(user.username);
  }

  /// currentUser unfollows [user]
  Future unfollow(User user) async {
    await _followService.unfollowByUser(user);
  }
}
