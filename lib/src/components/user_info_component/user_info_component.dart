import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/model/user.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/db_service.dart';
import 'package:whalefeed/src/services/direction_service.dart';
import 'package:whalefeed/src/services/input_cleaner_service.dart';
import 'package:whalefeed/src/services/orderer_service.dart';

/// Component for the user info page
@Component(
    selector: 'my-user-info',
    templateUrl: 'user_info_component.html',
    styleUrls: const [
      'user_info_component.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    directives: const [
      coreDirectives,
      MaterialButtonComponent,
      MaterialIconComponent
    ],
    providers: const [
      materialProviders
    ])
class UserInfoComponent implements OnActivate {
  final AuthService _auth;
  final CurrentUserService _currentUser;
  final DBService _db;
  final DirectionService _direction;
  final InputCleanerService _cleaner;
  final OrdererService _orderer;
  User _userVisited;
  int _userFollowing, _userFollowed, _userMessages;
  String _mostWrittenSpace;

  /// Constructor
  UserInfoComponent(this._auth, this._cleaner, this._currentUser, this._db,
      this._direction, this._orderer);

  /// User with the info
  User get user => _userVisited;

  /// Number of followings
  int get userFollowing => _userFollowing;

  /// Number of followed
  int get userFollowed => _userFollowed;

  /// Number of messages
  int get userMessages => _userMessages;

  /// Space name where the user has written most messages in
  String get mostWrittenSpace => _mostWrittenSpace;

  /// Goes to signin
  void goToSignIn() => _direction.goToSignIn();

  /// Goes back to the user visited profile
  void goBackToUserProfile() =>
      _direction.goToUserProfile(_userVisited.username);

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
      _userMessages = _userVisited.messages.length;

      if (_userMessages > 0) {
        _mostWrittenSpace = _orderer.getMostWrittenIn(_userVisited.messages);
      } else {
        _mostWrittenSpace = 'this user has no messages';
      }
    }
  }
}
