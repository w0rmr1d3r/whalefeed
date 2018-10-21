import 'dart:collection';

/// Service to order lists and maps
class OrdererService {
  /// Constructor
  OrdererService();

  /// Return a list of lists containing the space name and the total messages
  List<List<String>> orderSpacesByMostWritten(
      Map<String, dynamic> userMessages) {
    Map<String, int> spacesUnordered = {};
    List<List<String>> spacesOrdered = [];

    userMessages.values.toList().forEach((item) {
      if (spacesUnordered.containsKey(item)) {
        spacesUnordered[item]++;
      } else {
        spacesUnordered.addAll({item: 1});
      }
    });

    List orderedKeys = spacesUnordered.keys.toList()
      ..sort((a, b) => spacesUnordered[b].compareTo(spacesUnordered[a]));

    new LinkedHashMap.fromIterable(orderedKeys,
        key: (k) => k, value: (k) => spacesUnordered[k]).forEach((key, value) {
      spacesOrdered.add([key, value.toString()]);
    });

    return spacesOrdered;
  }

  /// Gets the space most written in from the user messages map
  String getMostWrittenIn(Map<String, dynamic> userMessages) =>
      orderSpacesByMostWritten(userMessages)[0][0];
}
