import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/app_layout/material_temporary_drawer.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_list/material_list_item.dart';
import 'package:angular_router/angular_router.dart';

import 'package:dart_toast/dart_toast.dart';

import 'package:whalefeed/src/components/message_component/message_component.dart';
import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/model/message.dart';
import 'package:whalefeed/src/model/space.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/converter_service.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/db_service.dart';
import 'package:whalefeed/src/services/direction_service.dart';
import 'package:whalefeed/src/services/input_cleaner_service.dart';

/// Component that manages the messages showing
@Component(
    selector: 'my-main',
    templateUrl: 'main_component.html',
    styleUrls: const [
      'main_component.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    directives: const [
      coreDirectives,
      DeferredContentDirective,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialListComponent,
      MaterialListItemComponent,
      MaterialTemporaryDrawerComponent,
      MessageDetailComponent
    ],
    providers: const [
      materialProviders
    ])
class MainComponent implements OnActivate {
  final AuthService _auth;
  final ConverterService _converter;
  final CurrentUserService _currentUser;
  final DBService _db;
  final DirectionService _direction;
  final InputCleanerService _cleaner;
  final String _whalefeedText = 'Whalefeed';
  final List<List<String>> _spaces = [];
  List<Message> _messages = [];
  String _navigationTitle = 'Whalefeed';

  /// Constructor
  MainComponent(this._auth, this._cleaner, this._converter, this._currentUser,
      this._db, this._direction);

  /// Spaces for the lateral menu
  List<List<String>> get spaces => _spaces;

  /// Messages to show
  List<Message> get messages => _messages;

  /// Title for the navigation bar
  String get navigationTitle => _navigationTitle;

  /// Goes to the about section page
  void goToAboutSection() => _direction.goToAboutSection();

  /// Goes to the changes section page
  void goToChangelogSection() => _direction.goToChangelogSection();

  /// Goes to the message creation page
  void goToCreateMessage() => _direction.goToCreateMessage();

  /// Goes to the space creation page
  void goToCreateSpace() => _direction.goToCreateSpace();

  /// Goes to search
  void goToSearch() => _direction.goToSearch();

  /// Goes to sign in
  void goToSignIn() => _direction.goToSignIn();

  /// Goes to settings
  void goToSettings() => _direction.goToSettings();

  /// Returns here to load all messages
  void goToMain() => _direction.goToMain('');

  /// Goes to edit spaces
  void goToEditSpaces() => _direction.goToEditSpaces();

  /// Goes to the user signed in profile
  void goToUserProfile() =>
      _direction.goToUserProfile(_currentUser.user.username);

  /// Goes to the [clickedSpace] space
  void goToClickedSpace(String clickedSpace) =>
      _direction.goToMain(clickedSpace);

  /// Goes to chat
  void goToChat() {
    new Toast('', 'Feature in progress', position: ToastPos.topCenter);
  }

  /// Signs out
  void signOut() {
    _auth.signOut();
    _direction.goToIndex();
  }

  @override
  Future onActivate(RouterState previous, RouterState current) async {
    if (_auth.currentUser == null || !_cleaner.isValid(_auth.currentUserID)) {
      goToSignIn();
    } else {
      if (_currentUser.user == null) {
        goToSignIn();
      } else {
        Map params = current.parameters;
        // TODO : this loading goes to a common service (also for userspace component)

        var spaceNameParam = params.isEmpty ? '' : params[spacenameKey];
        if (_cleaner.isValid(spaceNameParam)) {
          Space _currentSpace = await _db.getSpace(spaceNameParam);
          if (_currentSpace == null) {
            _navigationTitle = _whalefeedText;
            _messages = await _db.getMessages(_currentUser.user);
          } else {
            _navigationTitle = _currentSpace.name;
            _messages =
                await _db.getMessages(_currentUser.user, space: _currentSpace);
          }
        } else {
          _navigationTitle = _whalefeedText;
          _messages = await _db.getMessages(_currentUser.user);
        }

        if (_messages.isEmpty) {
          _messages.add(new Message(
              'This Space has no messages, be the first to write one!',
              '',
              _whalefeedText,
              new DateTime.now(),
              null));
        }
        _converter
            .convertMapToList(_currentUser.user.subscribedSpaces)
            .forEach((String spaceName) async {
          Space space = await _db.getSpace(spaceName);
          _spaces.add([space.name, space.official.toString()]);
        });
      }
    }
  }
}
