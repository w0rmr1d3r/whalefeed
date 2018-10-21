import 'dart:async';

import 'package:whalefeed/src/key_storage.dart';
import 'package:whalefeed/src/model/space.dart';
import 'package:whalefeed/src/services/current_user_service.dart';
import 'package:whalefeed/src/services/db_service.dart';
import 'package:whalefeed/src/services/follow_service.dart';
import 'package:whalefeed/src/services/input_cleaner_service.dart';
import 'package:whalefeed/src/services/json_parser_service.dart';

/// Service from the search component
class SearchService {
  final CurrentUserService _currentUser;
  final DBService _db;
  final FollowService _followService;
  final InputCleanerService _cleaner;
  final JSONParserService _jsonParserService;

  /// Constructor
  SearchService(this._cleaner, this._currentUser, this._db, this._followService,
      this._jsonParserService);

  /// The user subscribes to the [spaceName]
  Future subscribeToSpace(String spaceName) async {
    Space space = await _db.getSpace(spaceName);
    await space.addSubscriber(_currentUser.user, _db);
    await _currentUser.user.subscribeToSpace(space, _db);
  }

  /// The user signed in follows [username]
  Future followUser(String username) async {
    await _followService.followUser(username);
  }

  /// Search a user and space
  Future<Map<String, dynamic>> search(Map unparsedData) async {
    Map parsedData = _jsonParserService.getMapFromJSON(unparsedData);
    String userSearched, spaceSearched;
    bool success = false;

    if (parsedData.isNotEmpty &&
        parsedData.length == 1 &&
        parsedData.containsKey(inputsearchKey)) {
      Map inputSearchResult =
          _cleaner.cleanInputSearch((parsedData[inputsearchKey]).toString());
      String inputSearch = inputSearchResult[inputsearchKey];
      bool error = !inputSearchResult[successKey];

      if (!error) {
        Map searchResult = await _db.search(inputSearch);
        userSearched = searchResult[usernameKey];
        spaceSearched = searchResult[spacenameKey];
        success = true;
      }
    }

    return {
      successKey: success,
      usernameKey: userSearched,
      spacenameKey: spaceSearched
    };
  }
}
