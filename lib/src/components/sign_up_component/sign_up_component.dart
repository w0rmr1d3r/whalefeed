import 'dart:async';
import 'dart:core';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:whalefeed/src/components/navbar_component/navbar_component.dart';
import 'package:whalefeed/src/components/sign_up_component/sign_up_service.dart';
import 'package:whalefeed/src/feedback_messages.dart';
import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/routes.dart';
import 'package:whalefeed/src/services/direction_service.dart';
import 'package:whalefeed/src/directives/input_validator.dart';

/// Component for sign up
@Component(
    selector: 'my-sign-up',
    templateUrl: 'sign_up_component.html',
    styleUrls: const [
      'sign_up_component.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    directives: const [
      coreDirectives,
      formDirectives,
      materialInputDirectives,
      routerDirectives,
      AutoFocusDirective,
      InputValidator,
      NavbarComponent
    ],
    providers: const [
      materialProviders,
      ClassProvider(SignUpService)
    ],
    exports: [
      RoutePaths,
      correctMessage
    ])
class SignUpComponent {
  final DirectionService _direction;

  final SignUpService _componentService;

  /// Title for the navbar
  final String navbarTitle = 'Whalefeed';
  bool _submitError = false;
  bool _submitCorrect = false;
  String _errorMessage = 'Ups! An error has occurred :(';

  /// Constructor
  SignUpComponent(this._componentService, this._direction);

  /// Error message to show
  String get errorMessage => _errorMessage;

  /// Bool to know if an error has occurred
  bool get submitError => _submitError;

  /// Bool to know if the submit is correct
  bool get submitCorrect => _submitCorrect;

  /// Goes to sign in
  void goToSignIn() => _direction.goToSignIn();

  /// Processes submit for signup
  Future onSubmit(Map<String, dynamic> data) async {
    _submitError = false;
    _submitCorrect = false;

    Map<String, dynamic> result = await _componentService.performSignUp(data);

    _submitError = result[errorKey];
    _submitCorrect = result[successKey];
    _errorMessage = result[messageKey];

    if (_submitCorrect) {
      goToSignIn();
    }
  }
}
