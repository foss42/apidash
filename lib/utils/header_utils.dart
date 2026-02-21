import '../consts.dart';

List<String> getHeaderSuggestions(String pattern) {
  var matches = kHttpHeadersMap.keys
      .map((item) => (item.toLowerCase().indexOf(pattern.toLowerCase()), item))
      .where((element) => element.$1 >= 0)
      .toList();

  matches.sort((a, b) => a.$1.compareTo(b.$1));

  return matches.map((item) => item.$2).toList();
}

int getHeaderSize(Map<String, String>? headers) {
  if (headers == null || headers.isEmpty) {
    return 0;
  }
  int size = 0;
  headers.forEach((key, value) {
    // key: value\r\n
    size += key.length + value.length + 4;
  });
  return size;
}
