import '../consts.dart';

List<String> getHeaderSuggestions(String pattern) {
  var matches = kHttpHeadersMap.keys
      .map((item) => (item.toLowerCase().indexOf(pattern.toLowerCase()), item))
      .where((element) => element.$1 >= 0)
      .toList();

  matches.sort((a, b) => a.$1.compareTo(b.$1));

  return matches.map((item) => item.$2).toList();
}
