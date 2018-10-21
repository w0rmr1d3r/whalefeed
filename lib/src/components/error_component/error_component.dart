import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/components/navbar_component/navbar_component.dart';
import 'package:whalefeed/src/routes.dart';

/// Component for the error view
@Component(
    selector: 'my-error',
    templateUrl: 'error_component.html',
    styleUrls: const [
      'package:angular_components/app_layout/layout.scss.css'
    ],
    directives: const [
      routerDirectives,
      NavbarComponent
    ],
    exports: [
      RoutePaths
    ])
class ErrorComponent {
  /// Title for the navbar
  final String navbarTitle = 'Whalefeed';
}
