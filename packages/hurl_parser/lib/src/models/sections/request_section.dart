import 'package:hurl_parser/src/models/basic_auth.dart';
import 'package:hurl_parser/src/models/forms_params.dart';
import 'package:hurl_parser/src/models/misc_model.dart';
import 'package:hurl_parser/src/models/multipart_form_params.dart';
import 'package:hurl_parser/src/models/query_string_params.dart';
import 'package:hurl_parser/src/utils/utils.dart';

class RequestSection {
  final String type;
  final dynamic content;

  RequestSection({required this.type, required this.content});

  factory RequestSection.fromJson(Map<String, dynamic> json) {
    return RequestSection(
      type: json['type'],
      content: switch (json['type']) {
        'BasicAuth' => BasicAuth.fromJson(json['content']),
        'QueryStringParams' => QueryStringParams.fromJson(json['content']),
        'FormParams' => FormParams.fromJson(json['content']),
        'MultipartFormData' => MultipartFormData.fromJson(json['content']),
        'Cookies' => Cookies.fromJson(json['content']),
        'Options' => Options.fromJson(json['content']),
        _ => json['content'],
      },
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'content': content is Map ? content : content.toJson(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestSection &&
          type == other.type &&
          deepEquals(content, other.content);

  @override
  int get hashCode => type.hashCode ^ content.hashCode;
}
