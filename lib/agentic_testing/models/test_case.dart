import 'models.dart';

class TestCase {
  final String id;
  final String name;
  final String description;
  final TestSource source;
  final bool enabled;
  final List<String> tags;
  final Map<String, dynamic> requestPatch;
  final TestExpectation expectation;

  const TestCase({
    required this.id,
    required this.name,
    required this.description,
    required this.source,
    required this.expectation,
    this.enabled = true,
    this.tags = const [],
    this.requestPatch = const {},
  });

  TestCase copyWith({
    String? id,
    String? name,
    String? description,
    TestSource? source,
    bool? enabled,
    List<String>? tags,
    Map<String, dynamic>? requestPatch,
    TestExpectation? expectation,
  }) {
    return TestCase(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      source: source ?? this.source,
      enabled: enabled ?? this.enabled,
      tags: tags ?? this.tags,
      requestPatch: requestPatch ?? this.requestPatch,
      expectation: expectation ?? this.expectation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'source': source.name,
      'enabled': enabled,
      'tags': tags,
      'requestPatch': requestPatch,
      'expectation': expectation.toJson(),
    };
  }

  factory TestCase.fromJson(Map<String, dynamic> json) {
    return TestCase(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      source: _sourceFromString(json['source'] as String?),
      enabled: json['enabled'] as bool? ?? true,
      tags: (json['tags'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      requestPatch: Map<String, dynamic>.from(
        json['requestPatch'] as Map? ?? const {},
      ),
      expectation: TestExpectation.fromJson(
        Map<String, dynamic>.from(
          json['expectation'] as Map? ?? const {},
        ),
      ),
    );
  }

  static TestSource _sourceFromString(String? value) {
    return TestSource.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TestSource.rule,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TestCase &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.source == source &&
        other.enabled == enabled &&
        _listEquals(other.tags, tags) &&
        _mapEquals(other.requestPatch, requestPatch) &&
        other.expectation == expectation;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      source,
      enabled,
      Object.hashAll(tags),
      Object.hashAll(
        requestPatch.entries.map((e) => Object.hash(e.key, e.value)),
      ),
      expectation,
    );
  }

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key)) return false;
      if (a[key] != b[key]) return false;
    }
    return true;
  }
}