
class HurlEntry {
  final String method;
  final String url;
  final String? version;
  final Map<String, String>? headers;
  final String? body;

  HurlEntry({
    required this.method,
    required this.url,
    this.version,
    this.headers,
    this.body,
  });

  @override
  String toString() {
    return 'HurlEntry(method: $method, url: $url, headers: $headers, body: $body)';
  }
}
