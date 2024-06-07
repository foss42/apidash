import 'package:flutter/foundation.dart';

import 'environment_model.dart';

@immutable
class EnvironmentListModel {
  const EnvironmentListModel({
    this.actveEnvironment,
    this.globalEnvironment = const EnvironmentModel(id: "global"),
    this.environments = const [],
  });

  final EnvironmentModel? actveEnvironment;
  final EnvironmentModel globalEnvironment;
  final List<EnvironmentModel> environments;

  EnvironmentListModel copyWith({
    EnvironmentModel? actveEnvironment,
    EnvironmentModel? globalEnvironment,
    List<EnvironmentModel>? environments,
  }) {
    return EnvironmentListModel(
      actveEnvironment: actveEnvironment ?? this.actveEnvironment,
      globalEnvironment: globalEnvironment ?? this.globalEnvironment,
      environments: environments ?? this.environments,
    );
  }

  factory EnvironmentListModel.fromJson(Map<dynamic, dynamic> data) {
    final actveEnvironment = data["actveEnvironment"] != null
        ? EnvironmentModel.fromJson(
            data["actveEnvironment"] as Map<String, dynamic>)
        : null;
    final globalEnvironment = EnvironmentModel.fromJson(
        data["globalEnvironment"] as Map<String, dynamic>);
    final List<dynamic> environments = data["environments"] as List<dynamic>;

    const em = EnvironmentListModel();

    return em.copyWith(
      actveEnvironment: actveEnvironment,
      globalEnvironment: globalEnvironment,
      environments: environments
          .map((dynamic e) =>
              EnvironmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "actveEnvironment": actveEnvironment?.toJson(),
      "globalEnvironment": globalEnvironment.toJson(),
      "environments": environments.map((e) => e.toJson()).toList(),
    };
  }

  EnvironmentModel getEnvironment(String id) {
    if (id == "global") {
      return globalEnvironment;
    }
    return environments.firstWhere((e) => e.id == id);
  }

  @override
  bool operator ==(Object other) {
    return other is EnvironmentListModel &&
        other.actveEnvironment == actveEnvironment &&
        other.globalEnvironment == globalEnvironment &&
        listEquals(other.environments, environments);
  }

  @override
  int get hashCode {
    return Object.hash(
      actveEnvironment,
      globalEnvironment,
      environments,
    );
  }
}
