import 'assertion.dart';
import 'data_binding.dart';

class WorkflowStep {
  final String name;           // "Step 1 — POST /users"
  final String method;
  final String url;
  final Map<String, String> headers;
  final String? body;
  final List<Assertion> assertions;
  final List<DataBinding> dataExtractions;

  WorkflowStep({
    required this.name,
    required this.method,
    required this.url,
    required this.headers,
    this.body,
    required this.assertions,
    required this.dataExtractions,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'method': method,
        'url': url,
        'headers': headers,
        'body': body,
        'assertions': assertions.map((a) => a.toJson()).toList(),
        'dataExtractions': dataExtractions.map((d) => d.toJson()).toList(),
      };

  factory WorkflowStep.fromJson(Map<String, dynamic> json) => WorkflowStep(
      name: (json['name'] as String?) ?? 'Step ${json['method'] ?? 'unknown'}',
      method: (json['method'] as String?) ?? 'GET',
      url: (json['url'] as String?) ?? '',
      headers: Map<String, String>.from((json['headers'] as Map?) ?? const {}),
        body: json['body'] as String?,
      assertions: ((json['assertions'] as List?) ?? const [])
            .map((a) => Assertion.fromJson(a as Map<String, dynamic>))
            .toList(),
      dataExtractions: ((json['dataExtractions'] as List?) ?? const [])
            .map((d) => DataBinding.fromJson(d as Map<String, dynamic>))
            .toList(),
      );
}