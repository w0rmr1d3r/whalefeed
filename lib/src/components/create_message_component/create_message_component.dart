import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/components/create_message_component/create_message_service.dart';
import 'package:whalefeed/src/components/navbar_component/navbar_component.dart';
import 'package:whalefeed/src/directives/input_validator.dart';
import 'package:whalefeed/src/feedback_messages.dart';
import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/converter_service.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/direction_service.dart';

/// Component for the create message behaviour
@Component(
    selector: 'my-create-message',
    exports: [errorMessage],
    templateUrl: 'create_message_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      materialInputDirectives,
      AutoFocusDirective,
      InputValidator,
      MaterialButtonComponent,
      MaterialIconComponent,
      NavbarComponent
    ],
    providers: const [materialProviders, ClassProvider(CreateMessageService)])
class CreateMessageComponent implements OnActivate {
  final AuthService _auth;
  final ConverterService _converter;
  final CreateMessageService _componentService;
  final CurrentUserService _currentUser;
  final DirectionService _direction;

  /// Title for the navbar
  final String navbarTitle = 'Write a message';
  bool _messageCreationError = false;
  List<String> _userSpaces;

  /// Constructor
  CreateMessageComponent(this._auth, this._componentService, this._converter,
      this._currentUser, this._direction);

  /// Bool to know if the error message has to be shown
  bool get messageCreationError => _messageCreationError;

  /// Spaces for the message
  List<String> get userSpaces => _userSpaces;

  /// Goes to sign in
  void goToSignIn() => _direction.goToSignIn();

  /// Creates a message
  Future createMessage(Map<String, dynamic> data) async {
    Map result = await _componentService.createMessage(
        data, _userSpaces, _currentUser.user.username);
    _messageCreationError = result[errorKey];

    if (!_messageCreationError) {
      _direction.goToMain(result[spacenameKey]);
    }
  }

  @override
  void onActivate(RouterState previous, RouterState current) {
    if (_auth.currentUser == null) {
      goToSignIn();
    } else {
      _userSpaces =
          _converter.convertMapToList(_currentUser.user.subscribedSpaces);
    }
  }
}
