class ResourceDescriptor {
  final String uri;
  final String name;
  final String? description;
  final String? mimeType;

  ResourceDescriptor({
    required this.uri,
    required this.name,
    this.description,
    this.mimeType,
  });

  factory ResourceDescriptor.fromJson(Map<String, dynamic> json) {
    return ResourceDescriptor(
      uri: json['uri'] as String,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      mimeType: json['mimeType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uri': uri,
      'name': name,
      if (description != null) 'description': description,
      if (mimeType != null) 'mimeType': mimeType,
    };
  }
}

class Resource {
  final String uri;
  final String text;
  final String? mimeType;

  Resource({
    required this.uri,
    required this.text,
    this.mimeType,
  });

  Map<String, dynamic> toJson() {
    return {
      'uri': uri,
      'text': text,
      if (mimeType != null) 'mimeType': mimeType,
    };
  }
}

class ToolRequest {
  final String name;
  final Map<String, dynamic> parameters;

  ToolRequest({
    required this.name,
    required this.parameters,
  });

  factory ToolRequest.fromJson(Map<String, dynamic> json) {
    return ToolRequest(
      name: json['name'] as String,
      parameters: json['parameters'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'parameters': parameters,
    };
  }
}

class ToolResponse {
  final dynamic result;
  final String? error;

  ToolResponse({
    this.result,
    this.error,
  });

  factory ToolResponse.fromJson(Map<String, dynamic> json) {
    return ToolResponse(
      result: json['result'],
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (result != null) 'result': result,
      if (error != null) 'error': error,
    };
  }
}

class ToolDescriptor {
  final String name;
  final String description;
  final Map<String, dynamic> inputSchema;
  final McpUiToolMeta? uiMeta;

  ToolDescriptor({
    required this.name,
    required this.description,
    required this.inputSchema,
    this.uiMeta,
  });

  factory ToolDescriptor.fromJson(Map<String, dynamic> json) {
    return ToolDescriptor(
      name: json['name'] as String,
      description: json['description'] as String,
      inputSchema: json['inputSchema'] as Map<String, dynamic>,
      uiMeta: json['uiMeta'] != null 
          ? McpUiToolMeta.fromJson(json['uiMeta'] as Map<String, dynamic>) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'inputSchema': inputSchema,
      if (uiMeta != null) 'uiMeta': uiMeta!.toJson(),
    };
  }
}

class McpUiToolMeta {
  final String? icon;
  final String? color;
  final List<String>? categories;
  final bool? isDestructive;
  final McpUiPermissions? permissions;

  McpUiToolMeta({
    this.icon,
    this.color,
    this.categories,
    this.isDestructive,
    this.permissions,
  });

  factory McpUiToolMeta.fromJson(Map<String, dynamic> json) {
    return McpUiToolMeta(
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      categories: (json['categories'] as List?)?.cast<String>(),
      isDestructive: json['isDestructive'] as bool?,
      permissions: json['permissions'] != null 
          ? McpUiPermissions.fromJson(json['permissions'] as Map<String, dynamic>) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (categories != null) 'categories': categories,
      if (isDestructive != null) 'isDestructive': isDestructive,
      if (permissions != null) 'permissions': permissions!.toJson(),
    };
  }
}

class McpUiPermissions {
  final bool? needsNetwork;
  final bool? needsFileSystem;
  final List<String>? requiredEnv;

  McpUiPermissions({
    this.needsNetwork,
    this.needsFileSystem,
    this.requiredEnv,
  });

  factory McpUiPermissions.fromJson(Map<String, dynamic> json) {
    return McpUiPermissions(
      needsNetwork: json['needsNetwork'] as bool?,
      needsFileSystem: json['needsFileSystem'] as bool?,
      requiredEnv: (json['requiredEnv'] as List?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (needsNetwork != null) 'needsNetwork': needsNetwork,
      if (needsFileSystem != null) 'needsFileSystem': needsFileSystem,
      if (requiredEnv != null) 'requiredEnv': requiredEnv,
    };
  }
}
