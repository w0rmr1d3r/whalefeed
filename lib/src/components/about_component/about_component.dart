import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/components/about_info_component/about_info_component.dart';
import 'package:whalefeed/src/components/navbar_component/navbar_component.dart';
import 'package:whalefeed/src/routes.dart';

/// About component for the about view outside the app
@Component(
    selector: 'my-about',
    templateUrl: 'about_component.html',
    styleUrls: const ['package:angular_components/app_layout/layout.scss.css'],
    directives: const [routerDirectives, AboutInfoComponent, NavbarComponent],
    exports: [RoutePaths])
class AboutComponent {
  /// Title for the navbar
  final String navbarTitle = 'About';
}
