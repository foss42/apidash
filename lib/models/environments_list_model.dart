import 'package:flutter/foundation.dart';

class EnvironmentModel {
  final String id;
  final String name;
  final bool inEditMode;
  final Map<String, EnvironmentVariableModel> variables;
  List<EnvironmentVariableModel> get getEnvironmentVariables =>
      variables.values.toList();

  EnvironmentModel({
    required this.id,
    required this.name,
    required this.variables,
    required this.inEditMode,
  });

  EnvironmentModel copyWith({
    String? id,
    String? name,
    Map<String, EnvironmentVariableModel>? variables,
    bool? inEditMode,
  }) {
    return EnvironmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      variables: variables ?? this.variables,
      inEditMode: inEditMode ?? this.inEditMode,
    );
  }

  Map<String, dynamic>? toJson() {
    return {
      'id': id,
      'name': name,
      'variables': variables.values.map((e) => e.toJson()).toList(),
      'inEditMode': inEditMode,
    };
  }

  static EnvironmentModel fromJson(environmentVariables) {
    return EnvironmentModel(
      id: environmentVariables['id'],
      name: environmentVariables['name'],
      variables: environmentVariables['variables'],
      inEditMode: environmentVariables['inEditMode'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnvironmentModel &&
        other.id == id &&
        other.name == name &&
        other.inEditMode == inEditMode &&
        mapEquals(other.variables, variables);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        inEditMode.hashCode ^
        variables.hashCode;
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnvironmentVariableModel &&
        other.id == id &&
        other.variable == variable &&
        other.value == value &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^ variable.hashCode ^ value.hashCode ^ isActive.hashCode;
  }
}
