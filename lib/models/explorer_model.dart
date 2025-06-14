import 'models.dart';

class ApiTemplate {
  final Info info;
  final List requests;

  ApiTemplate({required this.info, required this.requests});

  /// Parses JSON data into an ApiTemplate object.
  factory ApiTemplate.fromJson(Map<String, dynamic> json) {
    return ApiTemplate(
      info: Info.fromJson(json['info'] ?? {}),
      requests: (json['requests'] as List?)
              ?.map((request) => RequestModel.fromJson(request))
              .toList() ??
          [],
    );
  }

  /// Converts the ApiTemplate back to JSON.
  Map<String, dynamic> toJson() {
    return {
      'info': info.toJson(),
      'requests': requests.map((request) => request.toJson()).toList(),
    };
  }
}

/// Represents metadata (e.g., title, description, tags).
class Info {
  final String title;
  final String description;
  final List<String> tags;

  Info({
    required this.title,
    required this.description,
    required this.tags,
  });

  /// Parses JSON data into an Info object.
  /// Future extensions: Add fields like category, version, or lastUpdated.
  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      title: json['title'] ?? 'Untitled',
      description: json['description'] ?? 'No description',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  /// Converts the Info object back to JSON.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'tags': tags,
    };
  }
}
