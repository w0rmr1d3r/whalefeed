import 'package:whalefeed/src/model/user.dart';
import 'package:whalefeed/src/services/db_service.dart';

/// Service to store the current user and do its actions
/// the signed in user belongs to the Auth Service
class CurrentUserService {
  final DBService _db;
  User _currentUser;

  /// Constructor
  CurrentUserService(this._db);

  /// Gets the current signed in user
  User get user => _currentUser;

  /// Gets the password from the current user
  String get password => _currentUser.password;

  /// Gets the email from the current user
  String get email => _currentUser.email;

  /// Inits service vars
  set init(User userSignedIn) => _currentUser = userSignedIn;

  /// Updates the last login
  void updateLastLogin() {
    DateTime loginDate = new DateTime.now();
    _db.updateLastLogin(loginDate);
  }

  void addFollowerListener(String username, String dateOnFollow) {
    _currentUser.followed.addAll({username: dateOnFollow});
  }

  void removeFollowerListener(String username) {
    _currentUser.followed.remove(username);
  }

  @override
  String toString() => 'CurrentUserService with User = $user';
}
