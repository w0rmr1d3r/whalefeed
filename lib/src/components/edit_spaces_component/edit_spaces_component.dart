import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/components/edit_spaces_component/edit_spaces_service.dart';
import 'package:whalefeed/src/components/navbar_component/navbar_component.dart';
import 'package:whalefeed/src/services/auth_service.dart';
import 'package:whalefeed/src/services/converter_service.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/direction_service.dart';

/// Component for the edit spaces behaviour
@Component(
    selector: 'my-edit-space',
    templateUrl: 'edit_spaces_component.html',
    directives: const [
      coreDirectives,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialListComponent,
      MaterialListItemComponent,
      NavbarComponent
    ],
    providers: const [
      ClassProvider(EditSpacesService)
    ])
class EditSpacesComponent implements OnActivate {
  final AuthService _auth;
  final ConverterService _converter;
  final CurrentUserService _currentUser;
  final DirectionService _direction;
  final EditSpacesService _componentService;

  /// Title for the navbar
  final String navbarTitle = 'Edit your Spaces';
  List<String> _userSpaces = [];

  /// Constructor
  EditSpacesComponent(this._auth, this._componentService, this._converter,
      this._currentUser, this._direction);

  /// List of spaces from the user
  List<String> get userSpaces => _userSpaces;

  /// Goes to sign in
  void goToSignIn() => _direction.goToSignIn();

  /// Unsubscribe from [space]
  Future unsubscribeFromSpace(String space) async {
    if (_userSpaces.length > 1) {
      // TODO : this 1 should be a constant
      _userSpaces.remove(space);
      await _componentService.unsubscribeFromSpace(space, _currentUser.user);
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
