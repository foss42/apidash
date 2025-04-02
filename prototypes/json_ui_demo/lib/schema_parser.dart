class FieldSchema {
  final String key;
  final String type;
  final String suggestedWidget;
  final String? label;
  final String? hintText;
  final String? icon;

  FieldSchema({
    required this.key,
    required this.type,
    required this.suggestedWidget,
    this.label,
    this.hintText,
    this.icon,
  });

  Map<String, dynamic> toJson() => {
    'key': key,
    'type': type,
    'suggestedWidget': suggestedWidget,
    if (label != null) 'label': label,
    if (hintText != null) 'hintText': hintText,
    if (icon != null) 'icon': icon,
  };

  factory FieldSchema.fromJson(Map<String, dynamic> json) {
    return FieldSchema(
      key: json['key'],
      type: json['type'],
      suggestedWidget: json['suggestedWidget'],
      label: json['label'],
      hintText: json['hintText'],
      icon: json['icon'],
    );
  }
}

class Schema {
  final String type;
  final List<FieldSchema> fields;

  Schema({required this.type, required this.fields});

  Map<String, dynamic> toJson() => {
    'type': type,
    'fields': fields.map((f) => f.toJson()).toList(),
  };

  factory Schema.fromJson(Map<String, dynamic> json) {
    return Schema(
      type: json['type'],
      fields: (json['fields'] as List<dynamic>)
          .map((f) => FieldSchema.fromJson(f))
          .toList(),
    );
  }
}

// backup plan rule based
String inferWidget(FieldSchema field) {
  final key = field.key.toLowerCase();
  final type = field.type;

  if (type == 'boolean') return 'Switch';
  if (type == 'number') return 'Text';
  if (type == 'string') {
    if (key.contains('email')) return 'EmailField';
    if (key.contains('url') || key.contains('link')) return 'UrlField';
    return 'Text';
  }
  if (type == 'array') return 'ListView';
  if (type == 'object') return 'Card';

  return 'Text';
}

Schema parseJsonToSchema(Map<String, dynamic> jsonObj) {
  List<FieldSchema> fields = [];

  jsonObj.forEach((key, value) {
    String fieldType;

    if (value is String) {
      fieldType = 'string';
    } else if (value is int || value is double) {
      fieldType = 'number';
    } else if (value is bool) {
      fieldType = 'boolean';
    } else if (value is List) {
      fieldType = 'array';
    } else if (value is Map) {
      fieldType = 'object';
    } else {
      fieldType = 'unknown';
    }

    String widget = inferWidget(FieldSchema(
      key: key,
      type: fieldType,
      suggestedWidget: '',
    ));

    fields.add(FieldSchema(
      key: key,
      type: fieldType,
      suggestedWidget: widget,
      label: key, 
      hintText: null,
      icon: null,
    ));
  });

  return Schema(type: 'object', fields: fields);
}