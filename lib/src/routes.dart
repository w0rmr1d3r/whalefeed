import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/components/about_component/about_component.template.dart'
    as act;
import 'package:whalefeed/src/components/about_section_component/about_section_component.template.dart'
    as asct;
import 'package:whalefeed/src/components/changelog_section_component/changelog_section_component.template.dart'
    as cgct;
import 'package:whalefeed/src/components/create_message_component/create_message_component.template.dart'
    as cmct;
import 'package:whalefeed/src/components/create_space_component/create_space_component.template.dart'
    as csct;
import 'package:whalefeed/src/components/edit_spaces_component/edit_spaces_component.template.dart'
    as esct;
import 'package:whalefeed/src/components/error_component/error_component.template.dart'
    as ect;
import 'package:whalefeed/src/components/follow_list_component/follow_list_component.template.dart'
    as flct;
import 'package:whalefeed/src/components/index_component/index_component.template.dart'
    as ict;
import 'package:whalefeed/src/components/main_component/main_component.template.dart'
    as mct;
import 'package:whalefeed/src/components/not_found_component/not_found_component.template.dart'
    as nfct;
import 'package:whalefeed/src/components/search_component/search_component.template.dart'
    as sct;
import 'package:whalefeed/src/components/sign_in_component/sign_in_component.template.dart'
    as sict;
import 'package:whalefeed/src/components/sign_up_component/sign_up_component.template.dart'
    as suct;
import 'package:whalefeed/src/components/user_info_component/user_info_component.template.dart'
    as uict;
import 'package:whalefeed/src/components/user_profile_component/user_profile_component.template.dart'
    as upct;
import 'package:whalefeed/src/components/user_settings_component/user_settings_component.template.dart'
    as usct;
import 'package:whalefeed/src/components/user_space_component/user_space_component.template.dart'
    as uspct;

import 'route_paths.dart';

export 'route_paths.dart';

/// Route definitions for the app
class Routes {
  /// AboutComponent route definition
  static final RouteDefinition about = RouteDefinition(
      routePath: RoutePaths.about, component: act.AboutComponentNgFactory);

  /// AboutSectionComponent route definition
  static final RouteDefinition aboutSection = RouteDefinition(
      routePath: RoutePaths.aboutSection,
      component: asct.AboutSectionComponentNgFactory);

  /// ChangelogSectionComponent route definition
  static final RouteDefinition changelogSection = RouteDefinition(
      routePath: RoutePaths.changelogSection,
      component: cgct.ChangelogSectionComponentNgFactory);

  /// CreateMessageComponent route definition
  static final RouteDefinition createMessage = RouteDefinition(
      routePath: RoutePaths.createMessage,
      component: cmct.CreateMessageComponentNgFactory);

  /// CreateSpaceComponent route definition
  static final RouteDefinition createSpace = RouteDefinition(
      routePath: RoutePaths.createSpace,
      component: csct.CreateSpaceComponentNgFactory);

  /// EditSpacesComponent route definition
  static final RouteDefinition editSpaces = RouteDefinition(
      routePath: RoutePaths.editSpaces,
      component: esct.EditSpacesComponentNgFactory);

  /// ErrorComponent route definition
  static final RouteDefinition error = RouteDefinition(
      routePath: RoutePaths.error, component: ect.ErrorComponentNgFactory);

  /// FollowComponent route definition
  static final RouteDefinition followList = RouteDefinition(
      routePath: RoutePaths.followList,
      component: flct.FollowListComponentNgFactory);

  /// IndexComponent route definition
  static final RouteDefinition index = RouteDefinition(
      routePath: RoutePaths.index,
      component: ict.IndexComponentNgFactory,
      useAsDefault: true);

  /// MainComponent default route definition
  static final RouteDefinition mains = RouteDefinition(
      routePath: RoutePaths.mains, component: mct.MainComponentNgFactory);

  /// MainComponent route definition
  static final RouteDefinition main = RouteDefinition(
      routePath: RoutePaths.main, component: mct.MainComponentNgFactory);

  /// SearchComponent route definition
  static final RouteDefinition search = RouteDefinition(
      routePath: RoutePaths.search, component: sct.SearchComponentNgFactory);

  /// SignInComponent route definition
  static final RouteDefinition signIn = RouteDefinition(
      routePath: RoutePaths.signIn, component: sict.SignInComponentNgFactory);

  /// SignUpComponent route definition
  static final RouteDefinition signUp = RouteDefinition(
      routePath: RoutePaths.signUp, component: suct.SignUpComponentNgFactory);

  /// UserInfoComponent route definition
  static final RouteDefinition userInfo = RouteDefinition(
      routePath: RoutePaths.userInfo,
      component: uict.UserInfoComponentNgFactory);

  /// UserProfileComponent route definition
  static final RouteDefinition userProfile = RouteDefinition(
      routePath: RoutePaths.userProfile,
      component: upct.UserProfileComponentNgFactory);

  /// UserSettingsComponent route definition
  static final RouteDefinition userSettings = RouteDefinition(
      routePath: RoutePaths.userSettings,
      component: usct.UserSettingsComponentNgFactory);

  /// UserSpaceComponent route definition
  static final RouteDefinition userSpace = RouteDefinition(
      routePath: RoutePaths.userSpace,
      component: uspct.UserSpaceComponentNgFactory);

  /// NotFoundComponent route definition
  static final RouteDefinition notFound = RouteDefinition(
      routePath: RoutePaths.notFound,
      component: nfct.NotFoundComponentNgFactory);

  /// List with all route definitions
  static final all = <RouteDefinition>[
    about,
    aboutSection,
    changelogSection,
    createMessage,
    createSpace,
    editSpaces,
    error,
    followList,
    index,
    mains,
    main,
    search,
    signIn,
    signUp,
    userInfo,
    userProfile,
    userSettings,
    userSpace,
    notFound,
  ];
}
