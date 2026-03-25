class RuleInput {
  final String method;
  final String url;
  final Map<String, String> headers;
  final String? body;
  final bool endpointLikelyProtected;

  const RuleInput({
    required this.method,
    required this.url,
    this.headers = const {},
    this.body,
    this.endpointLikelyProtected = false,
  });

  bool get hasAuthHeader {
    final keys = headers.keys.map((e) => e.toLowerCase()).toList();
    return keys.contains('authorization');
  }

  bool get isJsonRequest {
    final contentType = headers.entries
        .firstWhere(
          (e) => e.key.toLowerCase() == 'content-type',
          orElse: () => const MapEntry('', ''),
        )
        .value
        .toLowerCase();
    return contentType.contains('json');
  }

  bool get methodSupportsBody {
    final m = method.toUpperCase();
    return m == 'POST' || m == 'PUT' || m == 'PATCH' || m == 'DELETE';
  }

  bool get hasBody => (body ?? '').trim().isNotEmpty;
}