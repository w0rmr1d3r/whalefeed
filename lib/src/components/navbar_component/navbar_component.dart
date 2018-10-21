import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:whalefeed/src/services/direction_service.dart';

/// Component for the navbar on top of the views
@Component(
    selector: 'my-navbar',
    templateUrl: 'navbar_component.html',
    styleUrls: const [
      'navbar_component.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    directives: const [
      coreDirectives,
      MaterialButtonComponent,
      MaterialIconComponent
    ])
class NavbarComponent {
  /// Title to show in the navbar
  @Input()
  String title;

  /// Tells if the chevron_left icon will appear or not
  @Input()
  bool hasBackButton;

  final DirectionService _direction;

  /// Constructor
  NavbarComponent(this._direction);

  /// Goes back to main
  void goBackToMain() => _direction.goToMain(''); // TODO : this is a constant
}
