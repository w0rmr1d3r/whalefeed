import 'package:whalefeed/src/key_storage.dart';

/// Service to clean and validate inputs and strings
class InputCleanerService {
  final String _passwordRegexp = 'A-Za-z0-9._';
  final String _usernameRegexp = 'A-Za-z0-9._';
  final String _languageRegexp = 'A-Za-z_';
  final int _minLengthUsername = 2;
  final int _maxLengthUsername = 16;
  final int _minLengthPassword = 8;
  final int _maxLengthPassword = 32;
  final int _minLengthEmail = 5;
  final int _minLengthLanguage = 2;
  final int _maxLengthLanguage = 5;
  final int _minLengthMessage = 2;
  final int _maxLengthMessage = 1000;
  final int _minLengthSpaceName = 2;
  final int _maxLengthSpaceName = 30;
  final int _minLengthInputSearch = 2;
  final int _maxLengthInputSearch = 30;
  final int _minLengthDescription = 2;
  final int _maxLengthDescription = 120;

  /// Returns whether the [stringToCheck] to
  /// check is valid or not
  bool isValid(String stringToCheck) =>
      stringToCheck.isNotEmpty &&
      stringToCheck != null &&
      stringToCheck != 'null' &&
      !stringToCheck.contains('\n');

  /// Returns if the [stringToCheck] is between [minLength] and [maxLength]
  /// if [maxLength] is not specified, returns only if it's greater
  /// than [minLength]
  bool _isBetweenLength(String stringToCheck, int minLength, [int maxLength]) =>
      stringToCheck.length >= minLength &&
      (maxLength == null || stringToCheck.length <= maxLength);

  /// Returns the [string] with characters from [chars]
  /// as a Regexp replaced with empty
  String _whitelist(String string, String chars) =>
      string.replaceAll(new RegExp('[^$chars]+'), '');

  /// Cleans the [email] and returns whether is valid or not
  Map<String, dynamic> cleanEmail(String email) => {
        emailKey: email,
        successKey: isValid(email) && _isBetweenLength(email, _minLengthEmail)
      };

  /// Cleans the [password] and returns whether is valid or not
  Map<String, dynamic> cleanPassword(String password) => {
        passwordKey: _whitelist(password, _passwordRegexp),
        successKey: isValid(password) &&
            _isBetweenLength(password, _minLengthPassword, _maxLengthPassword)
      };

  /// Cleans the [username] and returns whether is valid or not
  Map<String, dynamic> cleanUsername(String username) => {
        usernameKey: _whitelist(username, _usernameRegexp),
        successKey: isValid(username) &&
            _isBetweenLength(username, _minLengthUsername, _maxLengthUsername)
      };

  /// Cleans the [language] and returns whether is valid or not and
  /// if it's inside the [validLanguages]
  Map<String, dynamic> cleanLanguage(
          String language, List<String> validLanguages) =>
      {
        languageKey: _whitelist(language, _languageRegexp),
        successKey: isValid(language) &&
            _isBetweenLength(
                language, _minLengthLanguage, _maxLengthLanguage) &&
            validLanguages.contains(language)
      };

  /// Cleans the [message] and returns whether is valid or not
  Map<String, dynamic> cleanMessageContent(String message) => {
        messageKey: message,
        successKey: isValid(message) &&
            _isBetweenLength(message, _minLengthMessage, _maxLengthMessage)
      };

  /// Cleans the [spaceName] and returns whether is valid or not
  Map<String, dynamic> cleanSpaceName(String spaceName) => {
        spacenameKey: spaceName,
        successKey: isValid(spaceName) &&
            _isBetweenLength(
                spaceName, _minLengthSpaceName, _maxLengthSpaceName)
      };

  /// Cleans the [inputSearch] and returns whether is valid or not
  Map<String, dynamic> cleanInputSearch(String inputSearch) => {
        inputsearchKey: inputSearch,
        successKey: isValid(inputSearch) &&
            _isBetweenLength(
                inputSearch, _minLengthInputSearch, _maxLengthInputSearch)
      };

  /// Cleans the [description] and returns whether is valid or not
  Map<String, dynamic> cleanDescription(String description) => {
        descriptionKey: description,
        successKey: isValid(description) &&
            _isBetweenLength(
                description, _minLengthDescription, _maxLengthDescription)
      };
}
