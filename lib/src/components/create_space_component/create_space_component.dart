import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/components/create_space_component/create_space_service.dart';
import 'package:whalefeed/src/components/navbar_component/navbar_component.dart';
import 'package:whalefeed/src/directives/input_validator.dart';
import 'package:whalefeed/src/feedback_messages.dart';
import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/direction_service.dart';

/// Message for the create space behaviour
@Component(
    selector: 'my-create-space',
    exports: [errorMessage],
    templateUrl: 'create_space_component.html',
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
    providers: const [materialProviders, ClassProvider(CreateSpaceService)])
class CreateSpaceComponent implements OnActivate {
  final AuthService _auth;
  final CreateSpaceService _componentService;
  final DirectionService _direction;

  /// Title for the navbar
  final String navbarTitle = 'Create a new Space';
  bool _submitError = false;

  /// Constructor
  CreateSpaceComponent(this._auth, this._componentService, this._direction);

  /// Bool to know if an error has occurred
  bool get submitError => _submitError;

  /// Goes to sign in
  void goToSignIn() => _direction.goToSignIn();

  /// Creates a space
  Future createSpace(Map<String, dynamic> data) async {
    Map result = await _componentService.createSpace(data);
    _submitError = result[errorKey];
    if (!_submitError) {
      _direction.goToMain(result[spacenameKey]);
    }
  }

  @override
  void onActivate(RouterState previous, RouterState current) {
    if (_auth.currentUser == null) {
      goToSignIn();
    }
  }
}
