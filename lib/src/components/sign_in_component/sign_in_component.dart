import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import 'package:firebase/firebase.dart' as fb;

import 'package:whalefeed/src/components/navbar_component/navbar_component.dart';
import 'package:whalefeed/src/components/sign_in_component/sign_in_service.dart';
import 'package:whalefeed/src/feedback_messages.dart';
import 'package:whalefeed/src/routes.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/direction_service.dart';
import 'package:whalefeed/src/directives/input_validator.dart';

/// Component for the sign in behaviour
@Component(
    selector: 'my-sign-in',
    templateUrl: 'sign_in_component.html',
    styleUrls: const [
      'sign_in_component.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    directives: const [
      coreDirectives,
      formDirectives,
      materialInputDirectives,
      routerDirectives,
      AutoFocusDirective,
      InputValidator,
      MaterialCheckboxComponent,
      NavbarComponent
    ],
    providers: const [
      materialProviders,
      ClassProvider(SignInService)
    ],
    exports: [
      RoutePaths,
      signInError
    ])
class SignInComponent implements OnActivate {
  final AuthService _auth;
  final DirectionService _direction;
  final SignInService _componentService;

  /// Title for the navbar
  final String navbarTitle = 'Whalefeed';
  bool _submitError = false;

  /// Constructor
  SignInComponent(this._auth, this._componentService, this._direction);

  /// Bool to know whether exist an error
  bool get submitError => _submitError;

  /// Goes to main
  void goToMain() => _direction.goToMain('');

  /// Submit and signs in
  Future onSubmit(Map<String, dynamic> data) async {
    _submitError = false;
    _submitError = await _componentService.performOnSubmit(data);
  }

  @override
  void onActivate(RouterState previous, RouterState current) {
    _auth.fbAuth.onAuthStateChanged.listen((fb.User user) async {
      if (user != null) {
        await _componentService.initCurrentUser();
        _componentService
          ..updateLastLogin()
          ..initCurrentUserListeners();
        goToMain();
      }
    });
  }
}
