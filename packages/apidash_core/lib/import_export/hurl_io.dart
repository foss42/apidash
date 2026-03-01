import 'package:hurl_parser/hurl_parser.dart';
import 'package:apidash_core/apidash_core.dart';

class HurlIO {
  List<HttpRequestModel>? getHttpRequestModelList(String content) {
    try {
      final parser = HurlParser();
      final entries = parser.parse(content);
      
      if (entries.isEmpty) return null;

      return entries.map((entry) {
        HTTPVerb method;
        try {
          method = HTTPVerb.values.byName(entry.method.toUpperCase());
        } catch (_) {
          method = HTTPVerb.get; 
        }

        return HttpRequestModel(
          method: method,
          url: entry.url,
          headers: entry.headers != null ? mapToRows(entry.headers!) : null,
          body: entry.body,
          // Guess content type or default to text/json if body is present
          bodyContentType: entry.body != null ? ContentType.json : ContentType.text, 
        );
      }).toList();
    } catch (e) {
      return null;
    }
  }
}
