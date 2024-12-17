import 'package:hurl_parser/src/models/common/body_types_enums.dart';
import 'package:hurl_parser/src/utils/utils.dart';

class Body {
  final BodyType type;
  final dynamic content;

  Body({required this.type, required this.content});

  factory Body.fromJson(Map<String, dynamic> json) {
    return Body(
      type: BodyType.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['type'] as String).toLowerCase(),
        orElse: () => BodyType.text,
      ),
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name.toLowerCase(),
        'content': content,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Body && type == other.type && deepEquals(content, other.content);

  @override
  int get hashCode => type.hashCode ^ content.hashCode;
}
