
import 'package:hurl_parser/hurl_parser.dart';

class Cookies {
  final List<KeyValue> cookies;

  Cookies({required this.cookies});

  factory Cookies.fromJson(Map<String, dynamic> json) {
    return Cookies(
      cookies:
          (json['cookies'] as List).map((e) => KeyValue.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'cookies': cookies.map((e) => e.toJson()).toList(),
      };
}

class Options {
  final List<Option> options;

  Options({required this.options});

  factory Options.fromJson(Map<String, dynamic> json) {
    return Options(
      options:
          (json['options'] as List).map((e) => Option.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'options': options.map((e) => e.toJson()).toList(),
      };
}

class Option {
  final String type;
  final dynamic value;

  Option({required this.type, required this.value});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'value': value,
      };
}

class Captures {
  final List<Capture> captures;

  Captures({required this.captures});

  factory Captures.fromJson(Map<String, dynamic> json) {
    return Captures(
      captures:
          (json['captures'] as List).map((e) => Capture.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'captures': captures.map((e) => e.toJson()).toList(),
      };
}

class Capture {
  final String name;
  final Query query;
  final List<Filter> filters;

  Capture({
    required this.name,
    required this.query,
    this.filters = const [],
  });

  factory Capture.fromJson(Map<String, dynamic> json) {
    return Capture(
      name: json['name'],
      query: Query.fromJson(json['query']),
      filters:
          (json['filters'] as List?)?.map((e) => Filter.fromJson(e)).toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'query': query.toJson(),
        'filters': filters.map((e) => e.toJson()).toList(),
      };
}

class Asserts {
  final List<Assert> asserts;

  Asserts({required this.asserts});

  factory Asserts.fromJson(Map<String, dynamic> json) {
    return Asserts(
      asserts:
          (json['asserts'] as List).map((e) => Assert.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'asserts': asserts.map((e) => e.toJson()).toList(),
      };
}

class Assert {
  final Query query;
  final List<Filter> filters;
  final Predicate predicate;

  Assert({
    required this.query,
    this.filters = const [],
    required this.predicate,
  });

  factory Assert.fromJson(Map<String, dynamic> json) {
    return Assert(
      query: Query.fromJson(json['query']),
      filters:
          (json['filters'] as List?)?.map((e) => Filter.fromJson(e)).toList() ??
              [],
      predicate: Predicate.fromJson(json['predicate']),
    );
  }

  Map<String, dynamic> toJson() => {
        'query': query.toJson(),
        'filters': filters.map((e) => e.toJson()).toList(),
        'predicate': predicate.toJson(),
      };
}

class KeyValue {
  final String key;
  final String value;

  KeyValue({required this.key, required this.value});

  factory KeyValue.fromJson(Map<String, dynamic> json) {
    return KeyValue(
      key: json['key'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
      };
}
