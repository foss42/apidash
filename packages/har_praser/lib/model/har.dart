import 'dart:convert';

/// Represents a parsed HAR file.
class Har {
  final List<HarEntry> entries;

  Har({required this.entries});

  /// Factory constructor that parses a JSON map into a Har object.
  factory Har.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('log') || json['log'] is! Map) {
      throw Exception("Invalid HAR: missing 'log' object.");
    }
    final log = json['log'] as Map<String, dynamic>;
    if (!log.containsKey('entries') || log['entries'] is! List) {
      throw Exception("Invalid HAR: missing 'entries' array.");
    }
    final List entriesJson = log['entries'];
    final entries = entriesJson
        .where((entry) => entry['request'] != null)
        .map<HarEntry>((entry) =>
            HarEntry.fromJson(entry['request'] as Map<String, dynamic>))
        .toList();

    return Har(entries: entries);
  }
}

/// Represents a single HAR entry request.
class HarEntry {
  final String method;
  final String url;
  final Map<String, String> headers;
  final String? body;

  HarEntry({
    required this.method,
    required this.url,
    required this.headers,
    this.body,
  });

  /// Parses a HAR request portion into a HarEntry.
  factory HarEntry.fromJson(Map<String, dynamic> json) {
    final String method = json['method'] as String;
    final String url = json['url'] as String;

    // Process headers from the headers list.
    final List<dynamic> headersList = json['headers'] as List? ?? [];
    final Map<String, String> headers = {};
    for (var header in headersList) {
      if (header['name'] != null && header['value'] != null) {
        headers[header['name'] as String] = header['value'] as String;
      }
    }

    // Optionally extract body from postData.
    final String? body = (json.containsKey('postData') &&
            json['postData'] is Map &&
            (json['postData'] as Map).containsKey('text'))
        ? (json['postData'] as Map)['text'] as String?
        : null;

    return HarEntry(
      method: method,
      url: url,
      headers: headers,
      body: body,
    );
  }
}