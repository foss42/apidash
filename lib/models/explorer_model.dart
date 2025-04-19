class ApiTemplate {
  final Info info;
  final List<Request> requests;

  ApiTemplate({required this.info, required this.requests});

  /// Parses JSON data into an ApiTemplate object.
  /// Future extensions: Add support for additional top-level fields (e.g., version, author).
  factory ApiTemplate.fromJson(Map<String, dynamic> json) {
    return ApiTemplate(
      info: Info.fromJson(json['info'] ?? {}),
      requests: (json['requests'] as List<dynamic>?)
              ?.map((request) => Request.fromJson(request))
              .toList() ??
          [],
    );
  }

  /// Converts the ApiTemplate back to JSON (useful for saving or debugging).
  /// Future extensions: Add serialization for new fields.
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

/// Represents a single API request within a template.
class Request {
  final String id;
  final String apiType;
  final String name;
  final String description;
  // Add more fields as needed (e.g., httpRequestModel, responseStatus).

  Request({
    required this.id,
    required this.apiType,
    required this.name,
    required this.description,
  });

  /// Parses JSON data into a Request object.
  /// Future extensions: Add parsing for httpRequestModel or other nested structures.
  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'] ?? '',
      apiType: json['apiType'] ?? 'unknown',
      name: json['name'] ?? 'Unnamed',
      description: json['description'] ?? 'No description',
    );
  }

  /// Converts the Request object back to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'apiType': apiType,
      'name': name,
      'description': description,
    };
  }
}