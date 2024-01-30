class EnvironmentsMapModel {
  final Map<String, EnvironmentModel>? environments;

  const EnvironmentsMapModel({
    this.environments,
  });
  // generate copy with method
  EnvironmentsMapModel copyWith({
    Map<String, EnvironmentModel>? environments,
  }) {
    return EnvironmentsMapModel(
      environments: environments ?? this.environments,
    );
  }

  get environmentsMap {
    return environments;
  }
}

class EnvironmentModel {
  final String id;
  final String name;
  final bool isActive;
  final bool inEditMode;
  final Map<String, EnvironmentVariableModel> variables;
  List<EnvironmentVariableModel> get getEnvironmentVariables =>
      variables.values.toList();

  EnvironmentModel({
    required this.id,
    required this.name,
    required this.variables,
    required this.isActive,
    required this.inEditMode,
  });

  EnvironmentModel copyWith({
    String? id,
    String? name,
    Map<String, EnvironmentVariableModel>? variables,
    bool? isActive,
    bool? inEditMode,
  }) {
    return EnvironmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      variables: variables ?? this.variables,
      isActive: isActive ?? this.isActive,
      inEditMode: inEditMode ?? this.inEditMode,
    );
  }

  Map<String, dynamic>? toJson() {
    return null;
  }

  static EnvironmentModel fromJson(environmentVariables) {
    return EnvironmentModel(
      id: environmentVariables['id'],
      name: environmentVariables['name'],
      variables: environmentVariables['variables'],
      isActive: environmentVariables['isActive'],
      inEditMode: environmentVariables['inEditMode'] ?? false,
    );
  }
}

class EnvironmentVariableModel {
  final String id;
  final String variable;
  final String value;
  final bool isActive;

  EnvironmentVariableModel({
    required this.id,
    required this.variable,
    required this.value,
    required this.isActive,
  });
  factory EnvironmentVariableModel.fromJson(Map<String, dynamic> json) {
    return EnvironmentVariableModel(
      id: json['id'],
      variable: json['variable'],
      value: json['value'],
      isActive: json['isActive'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'variable': variable,
      'value': value,
      'isActive': isActive,
    };
  }

  EnvironmentVariableModel copyWith({
    String? id,
    String? variable,
    String? value,
    bool? isActive,
  }) {
    return EnvironmentVariableModel(
      id: id ?? this.id,
      variable: variable ?? this.variable,
      value: value ?? this.value,
      isActive: isActive ?? this.isActive,
    );
  }
}
