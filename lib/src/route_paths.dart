import 'package:angular_router/angular_router.dart';

/// Paths to the components
class RoutePaths {
  /// username param, same as usernameKey
  static const String usernameParam = 'username';

  /// type param, same as typeKey
  static const String typeParam = 'type';

  /// spacename param, same as spacenameKey
  static const String spacenameParam = 'spacename';

  /// AboutComponent route
  static final RoutePath about = RoutePath(path: 'about');

  /// AboutSectionComponent route
  static final RoutePath aboutSection = RoutePath(path: 'aboutsection');

  /// ChangelogSectionComponent route
  static final RoutePath changelogSection = RoutePath(path: 'changes');

  /// CreateMessageComponent route
  static final RoutePath createMessage = RoutePath(path: 'createmessage');

  /// CreateSpaceComponent route
  static final RoutePath createSpace = RoutePath(path: 'createspace');

  /// EditSpacesComponent route
  static final RoutePath editSpaces = RoutePath(path: 'editspaces');

  /// ErrorComponent route
  static final RoutePath error = RoutePath(path: 'error');

  /// FollowComponent route
  static final RoutePath followList =
      RoutePath(path: 'follow/:$usernameParam/:$typeParam');

  /// IndexComponent route
  static final RoutePath index = RoutePath(path: 'index', useAsDefault: true);

  /// Main default rouote
  static final RoutePath mains = RoutePath(path: 'main');

  /// MainComponent route
  static final RoutePath main =
      RoutePath(path: '${mains.path}/:$spacenameParam');

  /// SearchComponent route
  static final RoutePath search = RoutePath(path: 'search');

  /// SignInComponent route
  static final RoutePath signIn = RoutePath(path: 'signin');

  /// SignUpComponent route
  static final RoutePath signUp = RoutePath(path: 'signup');

  /// UserInfoComponent route
  static final RoutePath userInfo = RoutePath(path: 'userinfo/:$usernameParam');

  /// UserProfileComponent route
  static final RoutePath userProfile =
      RoutePath(path: 'userprofile/:$usernameParam');

  /// UserSettingsComponent route
  static final RoutePath userSettings = RoutePath(path: 'usersettings');

  /// UserSpaceComponent route
  static final RoutePath userSpace =
      RoutePath(path: 'userspace/:$usernameParam/:$spacenameParam');

  /// NotFoundComponent route
  static final RoutePath notFound = RoutePath(path: '404');
}
