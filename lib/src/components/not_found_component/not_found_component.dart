import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:whalefeed/src/components/navbar_component/navbar_component.dart';

import 'package:whalefeed/src/routes.dart';

/// Component for the not found view
@Component(
    selector: 'my-not-found',
    templateUrl: 'not_found_component.html',
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
class NotFoundComponent {
  /// Title for the navbar
  final String navbarTitle = 'Whalefeed';
}
