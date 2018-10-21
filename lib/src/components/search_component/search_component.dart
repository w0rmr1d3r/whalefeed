import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/components/navbar_component/navbar_component.dart';
import 'package:whalefeed/src/components/search_component/search_service.dart';
import 'package:whalefeed/src/directives/input_validator.dart';
import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/direction_service.dart';
import 'package:whalefeed/src/services/input_cleaner_service.dart';

/// Component that manages search of users and spaces
@Component(
    selector: 'my-search',
    templateUrl: 'search_component.html',
    styleUrls: const [
      'search_component.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      InputValidator,
      MaterialButtonComponent,
      MaterialIconComponent,
      materialInputDirectives,
      MaterialTabPanelComponent,
      MaterialTabComponent,
      NavbarComponent
    ],
    providers: const [
      materialProviders,
      ClassProvider(SearchService)
    ])
class SearchComponent implements OnActivate {
  final AuthService _auth;
  final CurrentUserService _currentUser;
  final DirectionService _direction;
  final InputCleanerService _cleaner;
  final SearchService _componentService;

  /// Title for the navbar
  final String navbarTitle = 'Search';
  bool _success = false;
  String _followText = 'Follow';
  String _subscribeText = 'Subscribe';
  String _userSearched, _spaceSearched;

  /// Constructor
  SearchComponent(this._auth, this._cleaner, this._componentService,
      this._currentUser, this._direction);

  /// Bool to know if the search has been done
  bool get success => _success;

  /// The username found
  String get userSearched => _userSearched;

  /// The space found
  String get spaceSearched => _spaceSearched;

  /// Follow text for the button
  String get followText => _followText;

  /// Subscribe text for the button
  String get subscribeText => _subscribeText;

  /// Goes to sign in
  void goToSignIn() => _direction.goToSignIn();

  /// Goes back to main
  void goBackToMain(String space) => _direction.goToMain(space);

  /// Goes to the user with [username] profile
  void goToUserProfile(String username) => _direction.goToUserProfile(username);

  /// The user signed in subscribes to the [spaceName]
  Future subscribeToSpace(String spaceName) async {
    if (_cleaner.isValid(spaceName)) {
      goBackToMain(spaceName);
      await _componentService.subscribeToSpace(spaceName);
    }
  }

  /// The user signed in follows [username]
  Future followUser(String username) async {
    if (_cleaner.isValid(username)) {
      await _componentService.followUser(username);
      goToUserProfile(username);
    }
  }

  /// Search a user and space
  Future search(Map<String, dynamic> data) async {
    Map result = await _componentService.search(data);

    _userSearched = result[usernameKey];
    _spaceSearched = result[spacenameKey];
    _success = result[successKey];

    _followText = _currentUser.user.following.containsKey(_userSearched)
        ? 'Following'
        : 'Follow';
    _subscribeText =
        _currentUser.user.subscribedSpaces.containsKey(_spaceSearched)
            ? 'Subscribed'
            : 'Subscribe';
  }

  @override
  void onActivate(RouterState previous, RouterState current) {
    if (_auth.currentUser == null) {
      goToSignIn();
    }
  }
}
