import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/components/message_component/message_component.dart';
import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/model/message.dart';
import 'package:whalefeed/src/model/space.dart';
import 'package:whalefeed/src/model/user.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/db_service.dart';
import 'package:whalefeed/src/services/direction_service.dart';
import 'package:whalefeed/src/services/input_cleaner_service.dart';

/// Component for the user-space
@Component(
    selector: 'my-user-space',
    templateUrl: 'user_space_component.html',
    styleUrls: const [
      'user_space_component.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    directives: const [
      coreDirectives,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialListComponent,
      MaterialListItemComponent,
      MessageDetailComponent
    ],
    providers: const [
      materialProviders
    ])
class UserSpaceComponent implements OnActivate {
  final AuthService _auth;
  final CurrentUserService _currentUser;
  final DBService _db;
  final DirectionService _direction;
  final InputCleanerService _cleaner;
  List<Message> _messages = [];
  User _user;
  String _navigationTitle;

  /// Constructor
  UserSpaceComponent(
      this._auth, this._cleaner, this._currentUser, this._db, this._direction);

  /// Title for the navbar
  String get navigationTitle => _navigationTitle;

  /// Messages to show
  List<Message> get messages => _messages;

  /// Goes to sign in
  void goToSignIn() => _direction.goToSignIn();

  /// Goes to user profile
  void goBackToUserProfile() => _direction.goToUserProfile(_user.username);

  @override
  Future<void> onActivate(RouterState previous, RouterState current) async {
    if (_auth.currentUser == null) {
      goToSignIn();
    } else {
      Map params = current.parameters;
      var username = params[usernameKey];
      var spaceNameParam = params[spacenameKey];

      if (_cleaner.isValid(username) && _cleaner.isValid(spaceNameParam)) {
        if (username == _currentUser.user.username) {
          _user = _currentUser.user;
        } else {
          _user = await _db.getUser(username);
          _user ??= new User(
              'not found', 'not@found.gr', 'qwerty', null, {}, {}, {}, {});
        }
        Space _currentSpace = await _db.getSpace(spaceNameParam);

        if (_user != null && _currentSpace != null) {
          _navigationTitle = _currentSpace.name;
          _messages = await _db.getUserSpaceMessages(_user, _currentSpace);
        } else {
          goToSignIn();
        }
      } else {
        goToSignIn();
      }
    }
  }
}
