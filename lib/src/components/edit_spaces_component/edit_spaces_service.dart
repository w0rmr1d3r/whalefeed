import 'dart:async';

import 'package:whalefeed/src/model/space.dart';
import 'package:whalefeed/src/model/user.dart';
import 'package:whalefeed/src/services/db_service.dart';

/// Service from the edit spaces component
class EditSpacesService {
  final DBService _db;

  /// Constructor
  EditSpacesService(this._db);

  /// [user] unsubscribe from [space]
  Future unsubscribeFromSpace(String space, User user) async {
    Space selectedSpace = await _db.getSpace(space)
      ..unsubscribeUser(user, _db);
    user.unsubscribeFromSpace(selectedSpace, _db);
  }
}
