import 'package:args/args.dart';
import 'package:equatable/equatable.dart';
import 'package:seed/seed.dart';
import '../utils/string.dart';

const kHeaderContentType = 'Content-Type';

/// A representation of a cURL command in Dart.
///
/// The Curl class provides methods for parsing a cURL command string
/// and formatting a Curl object back into a cURL command.
class Curl extends Equatable {
  /// Specifies the HTTP request method (e.g., GET, POST, PUT, DELETE).
  final String method;

  /// Specifies the HTTP request URL.
  final Uri uri;

  /// Adds custom HTTP headers to the request.
  final Map<String, String>? headers;

  /// Sends data as the request body (typically used with POST requests).
  final String? data;

  /// Sends cookies with the request.
  final String? cookie;

  /// Specifies the username and password for HTTP basic authentication.
  final String? user;

  /// Sets the Referer header for the request.
  final String? referer;

  /// Sets the User-Agent header for the request.
  final String? userAgent;

  /// Sends data as a multipart/form-data request.
  final bool form;

  /// Form data list.
  final List<FormDataModel>? formData;

  /// Allows insecure SSL connections.
  final bool insecure;

  /// Follows HTTP redirects.
  final bool location;

  /// Constructs a new Curl object with the specified parameters.
  ///
  /// The `uri` parameter is required, while the remaining parameters are optional.
  Curl({
    required this.method,
    required this.uri,
    this.headers,
    this.data,
    this.cookie,
    this.user,
    this.referer,
    this.userAgent,
    this.form = false,
    this.formData,
    this.insecure = false,
    this.location = false,
  });

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
    final parser = ArgParser(allowTrailingOptions: true);

    parser.addOption('url');
    parser.addOption('request', abbr: 'X');
    parser.addMultiOption('header', abbr: 'H', splitCommas: false);
    parser.addMultiOption('data', abbr: 'd', splitCommas: false);
    parser.addMultiOption('data-raw', splitCommas: false);
    parser.addMultiOption('data-binary', splitCommas: false);
    parser.addMultiOption('data-urlencode', splitCommas: false);
    parser.addOption('cookie', abbr: 'b');
    parser.addOption('cookie-jar', abbr: 'c');
    parser.addOption('user', abbr: 'u');
    parser.addOption('oauth2-bearer');
    parser.addOption('referer', abbr: 'e');
    parser.addOption('user-agent', abbr: 'A');
    parser.addFlag('head', abbr: 'I');
    parser.addMultiOption('form', abbr: 'F');
    parser.addFlag('insecure', abbr: 'k');
    parser.addFlag('location', abbr: 'L');
    // Common non-request flags (ignored values)
    parser.addFlag('silent', abbr: 's');
    parser.addFlag('compressed');
    parser.addOption('output', abbr: 'o');
    parser.addFlag('include', abbr: 'i');
    parser.addFlag('globoff');
    // Additional flags often present in user commands; parsed and ignored
    parser.addFlag('verbose', abbr: 'v');
    parser.addOption('connect-timeout');
    parser.addOption('retry');

    if (!curlString.startsWith('curl ')) {
      throw Exception("curlString doesn't start with 'curl '");
    }

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
    if (result['header'] != null) {
      final List<String> headersList = result['header'];
      if (headersList.isNotEmpty) {
        headers = <String, String>{};
        for (final headerString in headersList) {
          final parts = headerString.split(RegExp(r':\s*'));
          if (parts.length > 2) {
            headers[parts.first] = parts.sublist(1).join(':');
          } else if (parts.length == 2) {
            headers[parts[0]] = parts[1];
          } else {
            throw Exception('Failed to split the `$headerString` header');
          }
        }
      }
    }

    // Form data
    List<FormDataModel>? formData;
    if (result['form'] is List<String> &&
        (result['form'] as List<String>).isNotEmpty) {
      formData = <FormDataModel>[];
      for (final entry in result['form']) {
        final pairs = entry.split('=');
        if (pairs.length != 2) {
          throw Exception('Form data entry $entry is not in key=value format');
        }
        final model = pairs[1].startsWith('@')
            ? FormDataModel(
                name: pairs[0],
                value: pairs[1].substring(1),
                type: FormDataType.file,
              )
            : FormDataModel(
                name: pairs[0],
                value: pairs[1],
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
      throw Exception('URL is null');
    }
    final uri = Uri.parse(url);

    // Method
    String method = result['head']
        ? 'HEAD'
        : ((result['request'] as String?)?.toUpperCase() ?? 'GET');

    // Data (preserve order)
    final List<String> dataPieces = [];
    void addDataList(dynamic v) {
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

  /// Converts the Curl object to a formatted cURL command string.
  String toCurlString() {
    var cmd = 'curl ';

    // Add the request method
    if (method != 'GET' && method != 'HEAD') {
      cmd += '-X $method ';
    }
    if (method == 'HEAD') {
      cmd += '-I ';
    }

    // Add the URL
    cmd += '"${Uri.encodeFull(uri.toString())}" ';

    void appendCont(String seg) {
      cmd += '\\';
      cmd += '\n ' + seg + ' ';
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
      cmd += '-k ';
    }
    if (location) {
      cmd += '-L ';
    }

    return cmd.trim();
  }

  @override
  List<Object?> get props => [
        method,
        uri,
        headers,
        data,
        cookie,
        user,
        referer,
        userAgent,
        form,
        formData,
        insecure,
        location,
      ];
}
