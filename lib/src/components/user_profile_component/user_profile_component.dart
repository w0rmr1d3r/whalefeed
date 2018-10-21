import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_list/material_list_item.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_router/angular_router.dart';

import 'package:dart_toast/dart_toast.dart';

import 'package:whalefeed/src/components/user_profile_component/user_profile_service.dart';
import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/model/user.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/db_service.dart';
import 'package:whalefeed/src/services/direction_service.dart';
import 'package:whalefeed/src/services/input_cleaner_service.dart';
import 'package:whalefeed/src/services/orderer_service.dart';

/// Component for the profile page
@Component(
    selector: 'my-user-profile',
    templateUrl: 'user_profile_component.html',
    styleUrls: const [
      'user_profile_component.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    directives: const [
      coreDirectives,
      MaterialButtonComponent,
      MaterialChipComponent,
      MaterialIconComponent,
      MaterialListComponent,
      MaterialListItemComponent
    ],
    providers: const [
      materialProviders,
      ClassProvider(UserProfileService)
    ])
class UserProfileComponent implements OnActivate {
  /// Text for the button
  static const String settingsText = 'SETTINGS';

  /// Text for the button
  static const String followText = 'FOLLOW';

  /// Text for the button
  static const String unfollowText = 'UNFOLLOW';

  final AuthService _auth;
  final CurrentUserService _currentUser;
  final DBService _db;
  final DirectionService _direciton;
  final InputCleanerService _cleaner;
  final OrdererService _orderer;
  final UserProfileService _componentService;
  List<List<String>> _spaces = [];
  String _actionButtonText = 'ACTION';
  User _userVisited;
  int _userFollowing, _userFollowed;

  /// Constructor
  UserProfileComponent(this._auth, this._cleaner, this._componentService,
      this._currentUser, this._db, this._direciton, this._orderer);

  /// List with the spaces and messages as string
  List<List<String>> get spaces => _spaces;

  /// User visited
  User get user => _userVisited;

  /// Number of following
  int get userFollowing => _userFollowing;

  /// Number of followed
  int get userFollowed => _userFollowed;

  /// Text for the button
  String get actionButtonText => _actionButtonText;

  /// Goes to create message
  void goToCreateMessage() => _direciton.goToCreateMessage();

  /// Goes to sign in
  void goToSignIn() => _direciton.goToSignIn();

  /// Goes back to main
  void goBackToMain() => _direciton.goToMain('');

  /// Goes to user info page
  void goToUserInfo() => _direciton.goToUserInfo(_userVisited.username);

  /// Goes to the chat
  void goToChat() {
    new Toast('', 'Feature in progress', position: ToastPos.topCenter);
  }

  /// Goes to user following/followed page
  void goToUserFollowing(String type) {
    if (type == followingKey || type == followedKey) {
      _direciton.goToUserFollowList(_userVisited.username, type);
    }
  }

  /// Goes to the user-space
  void goToUserSpace(String spacename) {
    _direciton.goToUserSpace(_userVisited.username, spacename);
  }

  /// Performs a user button action
  Future profileAction() async {
    switch (_actionButtonText) {
      case unfollowText:
        await _componentService.unfollow(_userVisited);
        _actionButtonText = followText;
        break;
      case followText:
        await _componentService.follow(_userVisited);
        _actionButtonText = unfollowText;
        break;
      case settingsText:
        _direciton.goToSettings();
        break;
      default:
        break;
    }
  }

  @override
  Future onActivate(RouterState previous, RouterState current) async {
    if (_auth.currentUser == null) {
      goToSignIn();
    } else {
      Map params = current.parameters;
      var username = params[usernameKey] ?? '';
      if (username == _currentUser.user.username) {
        _userVisited = _currentUser.user;
      } else {
        if (_cleaner.isValid(username)) {
          _userVisited = await _db.getUser(username);
        }
        _userVisited ??= new User(
            'not found', 'not@found.gr', 'qwerty', null, {}, {}, {}, {});
      }

      _userFollowing = _userVisited.following.isEmpty
          ? 0
          : _userVisited.following.length - 1;
      _userFollowed = _userVisited.followed.length;

      if (_userVisited.messages.isNotEmpty) {
        _spaces = _orderer.orderSpacesByMostWritten(_userVisited.messages);
      }

      if (_userVisited.username == 'not found' ||
          _userVisited.username == _currentUser.user.username) {
        _actionButtonText = settingsText;
      } else {
        _actionButtonText =
            _currentUser.user.following.containsKey(_userVisited.username)
                ? unfollowText
                : followText;
      }
    }
  }
}
