/// Service to order lists and maps
class ConverterService {
  /// Constructor
  ConverterService();

  /// Returns a list with the spaces name of a user given [userSpacesMap]
  List<String> convertMapToList(Map<String, dynamic> userSpacesMap) {
    List<String> userSpaces = [];
    userSpacesMap.keys.forEach(userSpaces.add);
    return userSpaces;
  }
}
