import 'dart:convert';

/// JSON Parser Service, parses from and to JSON
class JSONParserService {
  /// Gets a Map of values given an unparsed dynamic JSON
  Map getMapFromJSON(dynamic unparsedJSON) =>
      jsonDecode(jsonEncode(unparsedJSON));
}
