import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/components/about_info_component/about_info_component.dart';
import 'package:whalefeed/src/components/navbar_component/navbar_component.dart';

/// About component for the about section inside the app
@Component(
    selector: 'my-about-section',
    templateUrl: 'about_section_component.html',
    styleUrls: const ['package:angular_components/app_layout/layout.scss.css'],
    directives: const [routerDirectives, AboutInfoComponent, NavbarComponent])
class AboutSectionComponent {
  /// Title for the navbar
  final String navbarTitle = 'About';
}
