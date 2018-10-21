import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/components/navbar_component/navbar_component.dart';
import 'package:whalefeed/src/routes.dart';

/// Component for the index view
@Component(
    selector: 'my-index',
    templateUrl: 'index_component.html',
    directives: const [
      routerDirectives,
      NavbarComponent
    ],
    exports: [
      RoutePaths
    ])
class IndexComponent {
  /// Title for the navbar
  final String navbarTitle = 'Whalefeed';
}
