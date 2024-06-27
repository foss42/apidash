import '../consts.dart';

List<String> getHeaderSuggestions(String pattern) {
  return kHttpHeadersMap.keys
      .where(
        (element) => element.toLowerCase().contains(pattern.toLowerCase()),
      )
      .toList();
}
