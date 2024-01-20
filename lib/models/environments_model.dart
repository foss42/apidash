import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
class EnvironmentsModel {
  final String activeEnvironmentId;
  final List<EnvironmentModel> environments;

  const EnvironmentsModel({
    required this.activeEnvironmentId,
    required this.environments,
  });

  factory EnvironmentsModel.fromJson(Map<String, dynamic> json) {
    return EnvironmentsModel(
      activeEnvironmentId: json['activeEnvironmentId'],
      environments: (json['environments'] as List)
          .map((e) => EnvironmentModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeEnvironmentId': activeEnvironmentId,
      'environments': environments.map((e) => e.toJson()).toList(),
    };
  }

  EnvironmentsModel copyWith({
    String? activeEnvironmentId,
    List<EnvironmentModel>? environments,
  }) {
    return EnvironmentsModel(
      activeEnvironmentId: activeEnvironmentId ?? this.activeEnvironmentId,
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
  final List<EnvironmentVariableModel> variables;

  EnvironmentModel({
    required this.id,
    required this.name,
    required this.variables,
    required this.isActive,
  });

  factory EnvironmentModel.fromJson(Map<String, dynamic> json) {
    return EnvironmentModel(
      id: json['id'],
      name: json['name'],
      variables: (json['variables'] as List)
          .map((e) => EnvironmentVariableModel.fromJson(e))
          .toList(),
      isActive: json['isActive'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'variables': variables.map((e) => e.toJson()).toList(),
      'isActive': isActive,
    };
  }

  EnvironmentModel copyWith({
    String? id,
    String? name,
    List<EnvironmentVariableModel>? variables,
    bool? isActive,
  }) {
    return EnvironmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      variables: variables ?? this.variables,
      isActive: isActive ?? this.isActive,
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
