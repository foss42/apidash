import 'package:args/args.dart';
import 'package:seed/seed.dart';
import '../utils/string.dart';

part 'curl.freezed.dart';
part 'curl.g.dart';

/// The standard HTTP Content-Type header name.
const kHeaderContentType = 'Content-Type';

/// A [JsonConverter] that serializes [Uri] as a [String].
class UriJsonConverter implements JsonConverter<Uri, String> {
  const UriJsonConverter();

  @override
  Uri fromJson(String json) => Uri.parse(json);

  @override
  String toJson(Uri object) => object.toString();
}

/// A representation of a cURL command in Dart.
///
/// The Curl class provides methods for parsing a cURL command string
/// and formatting a Curl object back into a cURL command.
@freezed
@JsonSerializable(explicitToJson: true)
abstract class Curl with _$Curl {
  /// Private constructor to allow custom methods in a freezed class.
  const Curl._();

  /// Constructs a new Curl object with the specified parameters.
  ///
  /// The [method] and [uri] parameters are required, while the remaining
  /// parameters are optional.
  const factory Curl({
    /// Specifies the HTTP request method (e.g., GET, POST, PUT, DELETE).
    required String method,

    /// Specifies the HTTP request URL.
    @UriJsonConverter() required Uri uri,

    /// Adds custom HTTP headers to the request.
    Map<String, String>? headers,

    /// Sends data as the request body (typically used with POST requests).
    String? data,

    /// Sends cookies with the request.
    String? cookie,

    /// Specifies the username and password for HTTP basic authentication.
    String? user,

    /// Sets the Referer header for the request.
    String? referer,

    /// Sets the User-Agent header for the request.
    String? userAgent,

    /// Sends data as a multipart/form-data request.
    @Default(false) bool form,

    /// Form data list.
    List<FormDataModel>? formData,

    /// Allows insecure SSL connections.
    @Default(false) bool insecure,

    /// Follows HTTP redirects.
    @Default(false) bool location,
  }) = _Curl;

  /// Creates a [Curl] instance from a JSON map.
  factory Curl.fromJson(Map<String, dynamic> json) => _$CurlFromJson(json);

  /// Attempts to parse [curlString] as a [Curl] instance.
  ///
  /// Returns `null` if parsing fails instead of throwing an exception.
  static Curl? tryParse(String curlString) {
    try {
      return parse(curlString);
    } catch (_) {
      return null;
    }
  }

  /// Parse [curlString] as a [Curl] class instance.
  ///
  /// Example:
  /// ```dart
  /// print(Curl.parse('curl -X GET https://www.example.com/')); // Curl(method: 'GET', url: 'https://www.example.com/')
  /// print(Curl.parse('1f')); // [Exception] is thrown
  /// ```
  static Curl parse(String curlString) {
    if (!curlString.startsWith('curl ')) {
      throw FormatException("curlString doesn't start with 'curl '");
    }

    final parser = _buildArgParser();

    final tokens = splitAsCommandLineArgs(curlString.replaceFirst('curl ', ''));

    // Filter out unrecognized flags before parsing to avoid ArgParser errors
    final recognizedOptions = parser.options.keys.toSet();
    final recognizedAbbrs = parser.options.values
        .where((opt) => opt.abbr != null)
        .map((opt) => '-${opt.abbr}')
        .toSet();

    final filteredTokens = <String>[];
    for (var i = 0; i < tokens.length; i++) {
      final token = tokens[i];

      if (token.startsWith('--')) {
        final name = token.split('=').first.substring(2);
        if (recognizedOptions.contains(name)) {
          filteredTokens.add(token);
        } else {
          // Drop unknown long option; keep following token as positional
          continue;
        }
      } else if (token.startsWith('-') && token != '-') {
        if (recognizedAbbrs.contains(token)) {
          filteredTokens.add(token);
        } else {
          // Drop unknown short option
          continue;
        }
      } else {
        // Positional arg (likely URL)
        filteredTokens.add(token);
      }
    }

    final result = parser.parse(filteredTokens);

    // Headers
    Map<String, String>? headers;
    final List<String> headersList = result['header'] as List<String>;
    if (headersList.isNotEmpty) {
      headers = <String, String>{};
      for (final headerString in headersList) {
        final colonIndex = headerString.indexOf(':');
        if (colonIndex == -1) {
          throw FormatException(
            'Failed to split the `$headerString` header',
          );
        }
        final key = headerString.substring(0, colonIndex).trim();
        final value = headerString.substring(colonIndex + 1).trim();
        headers[key] = value;
      }
    }

    // Form data
    List<FormDataModel>? formData;
    final List<String> formEntries = result['form'] as List<String>;
    if (formEntries.isNotEmpty) {
      formData = <FormDataModel>[];
      for (final entry in formEntries) {
        final eqIndex = entry.indexOf('=');
        if (eqIndex == -1) {
          throw FormatException(
            'Form data entry $entry is not in key=value format',
          );
        }
        final key = entry.substring(0, eqIndex);
        final value = entry.substring(eqIndex + 1);
        final model = value.startsWith('@')
            ? FormDataModel(
                name: key,
                value: value.substring(1),
                type: FormDataType.file,
              )
            : FormDataModel(
                name: key,
                value: value,
                type: FormDataType.text,
              );
        formData.add(model);
      }
      headers ??= <String, String>{};
      if (!(headers.containsKey(kHeaderContentType) ||
          headers.containsKey(kHeaderContentType.toLowerCase()))) {
        headers[kHeaderContentType] = 'multipart/form-data';
      }
    }

    // URL
    String? url = clean(result['url']);
    if (url == null) {
      // Prefer the first URL-like positional token, else fallback to first
      String? firstUrlLike;
      for (final tok in result.rest) {
        final s = clean(tok);
        if (s == null) continue;
        final lower = s.toLowerCase();
        if (lower.startsWith('http://') || lower.startsWith('https://')) {
          firstUrlLike = s;
          break;
        }
      }
      url = firstUrlLike ?? clean(result.rest.firstOrNull);
    }
    if (url == null) {
      throw const FormatException('URL is null');
    }
    final uri = Uri.parse(url);

    // Method
    String method = result['head']
        ? 'HEAD'
        : ((result['request'] as String?)?.toUpperCase() ?? 'GET');

    // Data (preserve order)
    final dataPieces = <String>[];
    void addDataList(Object? v) {
      if (v is List<String>) dataPieces.addAll(v);
      if (v is String) dataPieces.add(v);
    }

    addDataList(result['data-urlencode']);
    addDataList(result['data-raw']);
    addDataList(result['data-binary']);
    addDataList(result['data']);
    final String? data = dataPieces.isNotEmpty ? dataPieces.join('&') : null;

    final String? cookie = result['cookie'];
    final String? user = result['user'];
    final String? oauth2Bearer = result['oauth2-bearer'];
    final String? referer = result['referer'];
    final String? userAgent = result['user-agent'];
    final bool form = formData != null && formData.isNotEmpty;
    final bool insecure = result['insecure'] ?? false;
    final bool location = result['location'] ?? false;

    // Apply oauth2-bearer to headers if present and no Authorization provided
    if (oauth2Bearer != null && oauth2Bearer.isNotEmpty) {
      headers ??= <String, String>{};
      final hasAuthHeader =
          headers.keys.any((k) => k.toLowerCase() == 'authorization');
      if (!hasAuthHeader) {
        headers['Authorization'] = 'Bearer $oauth2Bearer';
      }
    }

    // Default method to POST if body/form present and no explicit method
    if ((data != null || form) &&
        result['request'] == null &&
        !result['head']) {
      method = 'POST';
    }

    return Curl(
      method: method,
      uri: uri,
      headers: headers,
      data: data,
      cookie: cookie,
      user: user,
      referer: referer,
      userAgent: userAgent,
      form: form,
      formData: formData,
      insecure: insecure,
      location: location,
    );
  }

  /// Converts this [Curl] object to a formatted cURL command string.
  String toCurlString() {
    final buffer = StringBuffer('curl ');

    // Request method
    if (method != 'GET' && method != 'HEAD') {
      buffer.write('-X $method ');
    }
    if (method == 'HEAD') {
      buffer.write('-I ');
    }

    // URL
    buffer.write('"${Uri.encodeFull(uri.toString())}" ');

    void appendCont(String seg) {
      buffer.write('\\\n $seg ');
    }

    // Headers
    headers?.forEach((key, value) {
      appendCont('-H "$key: $value"');
    });

    // Form entries after headers
    if (form) {
      for (final formEntry in formData!) {
        final seg = formEntry.type == FormDataType.file
            ? '-F "${formEntry.name}=@${formEntry.value}"'
            : '-F "${formEntry.name}=${formEntry.value}"';
        appendCont(seg);
      }
    }

    // Body immediately after headers/form
    if (data?.isNotEmpty == true) {
      appendCont("-d '$data'");
    }

    // Cookie / user / referer / UA
    if (cookie?.isNotEmpty == true) {
      appendCont("-b '$cookie'");
    }
    if (user?.isNotEmpty == true) {
      appendCont("-u '$user'");
    }
    if (referer?.isNotEmpty == true) {
      appendCont("-e '$referer'");
    }
    if (userAgent?.isNotEmpty == true) {
      appendCont("-A '$userAgent'");
    }

    // Flags at end
    if (insecure) {
      buffer.write('-k ');
    }
    if (location) {
      buffer.write('-L ');
    }

    return buffer.toString().trim();
  }

  /// Builds the [ArgParser] for cURL command-line options.
  static ArgParser _buildArgParser() {
    final parser = ArgParser(allowTrailingOptions: true);

    // Request options
    parser.addOption('url');
    parser.addOption('request', abbr: 'X');
    parser.addMultiOption('header', abbr: 'H', splitCommas: false);

    // Data options
    parser.addMultiOption('data', abbr: 'd', splitCommas: false);
    parser.addMultiOption('data-raw', splitCommas: false);
    parser.addMultiOption('data-binary', splitCommas: false);
    parser.addMultiOption('data-urlencode', splitCommas: false);

    // Auth & identity
    parser.addOption('cookie', abbr: 'b');
    parser.addOption('cookie-jar', abbr: 'c');
    parser.addOption('user', abbr: 'u');
    parser.addOption('oauth2-bearer');
    parser.addOption('referer', abbr: 'e');
    parser.addOption('user-agent', abbr: 'A');

    // Request flags
    parser.addFlag('head', abbr: 'I');
    parser.addMultiOption('form', abbr: 'F');
    parser.addFlag('insecure', abbr: 'k');
    parser.addFlag('location', abbr: 'L');

    // Common non-request flags (parsed and ignored)
    parser.addFlag('silent', abbr: 's');
    parser.addFlag('compressed');
    parser.addOption('output', abbr: 'o');
    parser.addFlag('include', abbr: 'i');
    parser.addFlag('globoff');
    parser.addFlag('verbose', abbr: 'v');
    parser.addOption('connect-timeout');
    parser.addOption('retry');

    return parser;
  }
}
