import 'package:petitparser/petitparser.dart';
import '../models/hurl_entry.dart';

class HurlParser {
  Parser get _method =>
      (string('GET') |
       string('POST') |
       string('PUT') |
       string('DELETE') |
       string('PATCH') |
       string('HEAD') |
       string('OPTIONS') |
       word().plus().flatten())
          .trim();

  Parser get _url => newline().neg().plus().flatten().trim();

  // Header: Key: Value
  Parser get _headerKey => pattern('a-zA-Z0-9-').plus().flatten().trim();
  Parser get _headerValue => newline().neg().plus().flatten().trim();
  Parser get _header =>
      (_headerKey & char(':').trim() & _headerValue).map((l) => MapEntry(l[0] as String, l[2] as String));

  Parser get _headers =>
      (_header & newline().optional()).star().map((l) {
        final map = <String, String>{};
        for (var item in l) {
          if (item is List) {
             // Handle newline wrapping
             if (item[0] is MapEntry) {
                 final entry = item[0] as MapEntry<String, String>;
                 map[entry.key] = entry.value;
             }
          }
        }
        return map;
      });

  // Body: Everything after headers until next Request or End
  // For MVP, we assume one request per file or just take the rest as body
  Parser get _body => any().star().flatten().trim();

  // Comments
  Parser get _comment => (char('#') & newline().neg().star()).flatten().trim();
  Parser get _noise => (_comment | newline() | whitespace()).star();

  // Request: Method + URL + newline + Headers + newline + Body
  Parser get _request =>
      (_noise & _method & _url & newline().optional() & _headers & _body.optional())
          .map((l) => HurlEntry(
                method: l[1] as String,
                url: l[2] as String,
                headers: l[4] as Map<String, String>?,
                body: (l[5] as String?)?.isEmpty == true ? null : l[5] as String?,
              ));

  List<HurlEntry> parse(String content) {
    final result = _request.parse(content);
    if (result.isSuccess) {
      return [result.value];
    } else {
        // Fallback or better error handling
        print('Parse Error: ${result.message}');
      return [];
    }
  }
}
