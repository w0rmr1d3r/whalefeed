import 'package:angular_router/angular_router.dart';

import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/route_paths.dart';

/// Service to perform the goTo between components
class DirectionService {
  final Router _router;

  /// Constructor
  DirectionService(this._router);

  /// Goes to the about section page
  void goToAboutSection() =>
      _router.navigateByUrl(RoutePaths.aboutSection.toUrl());

  /// Goes to the changelog section page
  void goToChangelogSection() =>
      _router.navigateByUrl(RoutePaths.changelogSection.toUrl());

  /// Goes to the message creation page
  void goToCreateMessage() =>
      _router.navigateByUrl(RoutePaths.createMessage.toUrl());

  /// Goes to the space creation page
  void goToCreateSpace() =>
      _router.navigateByUrl(RoutePaths.createSpace.toUrl());

  /// Goes to edit spaces
  void goToEditSpaces() => _router.navigateByUrl(RoutePaths.editSpaces.toUrl());

  /// Goes to user following/followed page with [username] and [type]
  void goToUserFollowList(String username, String type) =>
      _router.navigateByUrl(RoutePaths.followList
          .toUrl(parameters: {usernameKey: username, typeKey: type}));

  /// Goes to index
  void goToIndex() => _router.navigateByUrl(RoutePaths.index.toUrl());

  /// Goes to main with [spaceName]
  void goToMain(String spaceName) => _router.navigate(
      RoutePaths.main.toUrl(parameters: {spacenameKey: '$spaceName'}));

  /// Goes to search
  void goToSearch() => _router.navigateByUrl(RoutePaths.search.toUrl());

  /// Goes to settings
  void goToSettings() => _router.navigateByUrl(RoutePaths.userSettings.toUrl());

  /// Goes to sign in
  void goToSignIn() => _router.navigateByUrl(RoutePaths.signIn.toUrl());

  /// Goes to user info with [username]
  void goToUserInfo(String username) => _router.navigateByUrl(
      RoutePaths.userInfo.toUrl(parameters: {usernameKey: username}));

  /// Goes to the user profile with [username]
  void goToUserProfile(String username) => _router.navigateByUrl(
      RoutePaths.userProfile.toUrl(parameters: {usernameKey: username}));

  /// Goes to the user-space with [username] and [spaceName]
  void goToUserSpace(String username, String spaceName) =>
      _router.navigateByUrl(RoutePaths.userSpace
          .toUrl(parameters: {usernameKey: username, spacenameKey: spaceName}));
}
