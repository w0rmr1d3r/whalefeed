import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/components/follow_list_component/follow_list_service.dart';
import 'package:whalefeed/src/feedback_messages.dart';
import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/model/user.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/db_service.dart';
import 'package:whalefeed/src/services/direction_service.dart';
import 'package:whalefeed/src/services/input_cleaner_service.dart';

/// Component that manages the following/followed list of the user
@Component(
    selector: 'my-follow-list',
    exports: [followError],
    templateUrl: 'follow_list_component.html',
    styleUrls: const [
      'follow_list_component.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    directives: const [
      coreDirectives,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialListComponent,
      MaterialListItemComponent
    ],
    providers: const [materialProviders, ClassProvider(FollowListService)])
class FollowListComponent implements OnActivate {
  final AuthService _auth;
  final CurrentUserService _currentUser;
  final FollowListService _componentService;
  final DBService _db;
  final DirectionService _direction;
  final InputCleanerService _cleaner;
  final List<List<String>> _followList = [];
  bool _showMessage = false;
  User _userVisited;
  Map<String, dynamic> _follow;
  String _showingType;

  /// Constructor
  FollowListComponent(this._auth, this._cleaner, this._componentService,
      this._currentUser, this._db, this._direction);

  /// List with the following and state
  List<List<String>> get followList => _followList;

  /// Title type
  String get showingType => _showingType;

  /// Bool to know if the message has to be shown
  bool get showMessage => _showMessage;

  /// Goes to the signin page
  void goToSignIn() => _direction.goToSignIn();

  /// Goes back to the user signed in profile
  void goBackToUserProfile() =>
      _direction.goToUserProfile(_userVisited.username);

  /// Goes to the user with [username] profile
  void goToUserProfile(String username) => _direction.goToUserProfile(username);

  /// Performs the action related to the button
  Future performAction(String usernameClicked, String type) async {
    if (_cleaner.isValid(usernameClicked) &&
        (type == followingKey || type == followedKey || type == selfKey)) {
      _followList.forEach((element) {
        if (element[0] == usernameClicked &&
            element[1] == type &&
            type != selfKey) {
          switch (type) {
            case followingKey:
              element[1] = followedKey;
              break;
            case followedKey:
              element[1] = followingKey;
              break;
            default:
              break;
          }
        }
      });

      await _componentService.performAction(type, usernameClicked);
    }
  }

  @override
  Future onActivate(RouterState previous, RouterState current) async {
    _showMessage = false;
    if (_auth.currentUser == null) {
      goToSignIn();
    } else {
      Map params = current.parameters;
      var type = params[typeKey] ?? '';

      if (type != followingKey && type != followedKey) {
        goToSignIn();
      } else {
        var username = params[usernameKey] ?? '';

        if (_cleaner.isValid(username)) {
          _userVisited = username == _currentUser.user.username
              ? _currentUser.user
              : await _db.getUser(username);
        }

        _userVisited ??= new User(
            'not found', 'not@found.gr', 'qwerty', null, {}, {}, {}, {});

        if (_userVisited.following.length <= 1 &&
            _userVisited.followed.isEmpty) {
          _showingType = followError;
          _showMessage = true;
        } else {
          switch (type) {
            case followingKey:
              _follow = new Map.from(_userVisited.following);
              _follow.remove(_userVisited.username);
              _showingType = 'Following';
              break;
            case followedKey:
              _follow = new Map.from(_userVisited.followed);
              _showingType = 'Followed';
              break;
            default:
              break;
          }

          if (_follow.isNotEmpty) {
            _follow.keys.toList()
              ..sort((a, b) => _follow[b].compareTo(_follow[a]))
              ..forEach((username) {
                if (username == _currentUser.user.username) {
                  _followList.add([username, selfKey]);
                } else {
                  _followList.add([
                    username,
                    (_currentUser.user.following.containsKey(username))
                        ? followingKey
                        : followedKey
                  ]);
                }
              });
          } else {
            _showMessage = true;
          }
        }
      }
    }
  }
}
