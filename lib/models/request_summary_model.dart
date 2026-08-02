import 'package:apidash_core/apidash_core.dart';

import 'request_model.dart';

class RequestSummary {
  const RequestSummary({
    required this.id,
    this.name = '',
    this.apiType = APIType.rest,
    this.method,
    this.url = '',
  });

  final String id;
  final String name;
  final APIType apiType;
  final HTTPVerb? method;
  final String url;

  factory RequestSummary.fromRequestModel(RequestModel model) {
    final httpUrl = model.httpRequestModel?.url.trim();
    final url = (httpUrl != null && httpUrl.isNotEmpty)
        ? httpUrl
        : model.aiRequestModel?.url.trim() ?? '';
    return RequestSummary(
      id: model.id,
      name: model.name,
      apiType: model.apiType,
      method: model.httpRequestModel?.method,
      url: url,
    );
  }

  factory RequestSummary.fromJson(Map<String, Object?> json) {
    final methodName = json['method'] as String?;
    return RequestSummary(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      apiType: APIType.values.byName(json['apiType'] as String? ?? 'rest'),
      method: methodName == null
          ? null
          : HTTPVerb.values.byName(methodName),
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'apiType': apiType.name,
        if (method != null) 'method': method!.name,
        'url': url,
      };
}
