import 'package:collection/collection.dart';

class EnvironmentsListModel {
  final List<EnvironmentModel> environments;

  const EnvironmentsListModel({
    required this.environments,
  });

  factory EnvironmentsListModel.fromJson(Map<String, dynamic> json) {
    return EnvironmentsListModel(
      environments: (json['environments'] as List)
          .map((e) => EnvironmentModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'environments': environments.map((e) => e.toJson()).toList(),
    };
  }

  EnvironmentsListModel copyWith({
    List<EnvironmentModel>? environments,
  }) {
    return EnvironmentsListModel(
      environments: environments ?? this.environments,
    );
  }

  EnvironmentModel? get getActiveEnvironment {
    return environments.firstWhereOrNull((e) => e.isActive);
  }

  int get getActiveEnvironmentIndex {
    return environments.indexWhere((e) => e.isActive);
  }
}

class EnvironmentModel {
  final String id;
  final String name;
  final bool isActive;
  final bool inEditMode;
  final List<EnvironmentVariableModel> variables;

  EnvironmentModel(
      {required this.id,
      required this.name,
      required this.variables,
      required this.isActive,
      required this.inEditMode});

  factory EnvironmentModel.fromJson(dynamic json) {
    return EnvironmentModel(
      id: json['id'],
      name: json['name'],
      variables: (json['variables'] as List)
          .map((e) => EnvironmentVariableModel.fromJson(e))
          .toList(),
      isActive: json['isActive'],
      inEditMode: json['inEditMode'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'variables': variables.map((e) => e.toJson()).toList(),
      'isActive': isActive,
      'inEditMode': inEditMode,
    };
  }

  EnvironmentModel copyWith({
    String? id,
    String? name,
    List<EnvironmentVariableModel>? variables,
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
