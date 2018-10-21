import 'package:angular/angular.dart';

import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/components/navbar_component/navbar_component.dart';

/// Component with the latest changes on the app
/// Content written from the file CHANGELOG.md
@Component(
    selector: 'my-changelog-section',
    templateUrl: 'changelog_section_component.html',
    styleUrls: const [
      'changelog_section_component.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    directives: const [
      routerDirectives,
      NavbarComponent
    ])
class ChangelogSectionComponent {
  /// Title for the navbar
  final String navbarTitle = 'Changes';
}
