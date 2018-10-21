import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_tab/material_tab.dart';
import 'package:angular_components/material_tab/material_tab_panel.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/components/navbar_component/navbar_component.dart';
import 'package:whalefeed/src/components/user_settings_component/user_settings_service.dart';
import 'package:whalefeed/src/directives/input_validator.dart';
import 'package:whalefeed/src/feedback_messages.dart';
import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/direction_service.dart';

/// Component for the settings
@Component(
    selector: 'my-user-settings',
    exports: [errorMessage, savedMessage],
    templateUrl: 'user_settings_component.html',
    styleUrls: const [
      'user_settings_component.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    directives: const [
      coreDirectives,
      formDirectives,
      materialInputDirectives,
      AutoFocusDirective,
      InputValidator,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialTabComponent,
      MaterialTabPanelComponent,
      NavbarComponent
    ],
    providers: const [materialProviders, ClassProvider(UserSettingsService)])
class UserSettingsComponent implements OnActivate {
  final AuthService _auth;
  final CurrentUserService _currentUser;
  final DirectionService _direction;
  final UserSettingsService _componentService;

  /// Title for the navbar
  final String navbarTitle = 'Settings';
  bool _languageSaved = false;
  bool _languageError = false;
  bool _emailSaved = false;
  bool _emailError = false;
  bool _passwordSaved = false;
  bool _passwordError = false;
  bool _descriptionSaved = false;
  bool _descriptionError = false;

  /// Constructor
  UserSettingsComponent(
      this._auth, this._componentService, this._currentUser, this._direction);

  static const _languagesList = const ['EN', 'ESP', 'CAT'];

  /// List of languages available
  List<String> get languages => _languagesList;

  /// Bool to know if the language has been saved
  bool get languageSaved => _languageSaved;

  /// Bool to know if an error has occurred while saving the language
  bool get languageError => _languageError;

  /// Bool to know if the email has been saved
  bool get emailSaved => _emailSaved;

  /// Bool to know if an error has occurred while saving the email
  bool get emailError => _emailError;

  /// Bool to know if the password has been saved
  bool get passwordSaved => _passwordSaved;

  /// Bool to know if an error has occurred while saving the password
  bool get passwordError => _passwordError;

  /// Bool to know if the description has been saved
  bool get descriptionSaved => _descriptionSaved;

  /// Bool to know if an error has occurred while saving the description
  bool get descriptionError => _descriptionError;

  /// Current user description
  String get currentDescription => _currentUser.user.description;

  /// Goes to sign in
  void goToSignIn() => _direction.goToSignIn();

  /// Resets the bools to show messages on tab change
  void onTabChange(TabChangeEvent event) {
    switch (event.newIndex) {
      case 0:
        _descriptionSaved = false;
        _descriptionError = false;
        break;
      case 1:
        _emailSaved = false;
        _emailError = false;
        break;
      case 2:
        _passwordSaved = false;
        _passwordError = false;
        break;
      case 3:
        _languageSaved = false;
        _languageError = false;
        break;
      default:
        break;
    }
  }

  /// Saves the new language
  Future saveLanguage(Map<String, dynamic> data) async {
    _languageError = false;
    _languageSaved = false;

    Map result = await _componentService.saveLanguage(data, _languagesList);
    _languageError = result[errorKey];
    _languageSaved = result[successKey];
  }

  /// Saves the new email
  Future saveEmail(Map<String, dynamic> data) async {
    _emailError = false;
    _emailSaved = false;

    Map result = await _componentService.saveEmail(data);
    _emailError = result[errorKey];
    _emailSaved = result[successKey];
  }

  /// Saves the new password
  Future savePassword(Map<String, dynamic> data) async {
    _passwordError = false;
    _passwordSaved = false;

    Map result = await _componentService.savePassword(data);
    _passwordError = result[errorKey];
    _passwordSaved = result[successKey];
  }

  /// Saves the new description
  Future saveDescription(Map<String, dynamic> data) async {
    _descriptionSaved = false;
    _descriptionError = false;

    Map result = await _componentService.saveDescription(data);
    _descriptionError = result[errorKey];
    _descriptionSaved = result[successKey];
  }

  @override
  void onActivate(RouterState previous, RouterState current) {
    if (_auth.currentUser == null) {
      goToSignIn();
    }
  }
}
