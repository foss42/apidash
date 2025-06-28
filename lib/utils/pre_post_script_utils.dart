import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/services.dart';

Future<RequestModel> handlePreRequestScript(
  RequestModel requestModel,
  EnvironmentModel? originalEnvironmentModel,
  void Function(EnvironmentModel, List<EnvironmentVariableModel>)? updateEnv,
) async {
  final scriptResult = await executePreRequestScript(
    currentRequestModel: requestModel,
    activeEnvironment: originalEnvironmentModel?.toJson() ?? {},
  );
  final newRequestModel =
      requestModel.copyWith(httpRequestModel: scriptResult.updatedRequest);
  if (originalEnvironmentModel != null) {
    final updatedEnvironmentMap = scriptResult.updatedEnvironment;

    final List<EnvironmentVariableModel> newValues = [];
    final Map<String, dynamic> mutableUpdatedEnv =
        Map.from(updatedEnvironmentMap);

    for (final originalVariable in originalEnvironmentModel.values) {
      if (mutableUpdatedEnv.containsKey(originalVariable.key)) {
        final dynamic newValue = mutableUpdatedEnv[originalVariable.key];
        newValues.add(
          originalVariable.copyWith(
            value: newValue == null ? '' : newValue.toString(),
            enabled: true,
          ),
        );

        mutableUpdatedEnv.remove(originalVariable.key);
      } else {
        // Variable was removed by the script (unset/clear), don't add it to newValues.
        // Alternatively, you could keep it but set enabled = false:
        // newValues.add(originalVariable.copyWith(enabled: false));
      }
    }

    for (final entry in mutableUpdatedEnv.entries) {
      final dynamic newValue = entry.value;
      newValues.add(
        EnvironmentVariableModel(
          key: entry.key,
          value: newValue == null ? '' : newValue.toString(),
          enabled: true,
          type: EnvironmentVariableType.variable,
        ),
      );
    }
    updateEnv?.call(originalEnvironmentModel, newValues);
  } else {
    debugPrint(
        "Skipped environment update as originalEnvironmentModel was null.");

    if (scriptResult.updatedEnvironment.isNotEmpty) {
      debugPrint(
          "Warning: Pre-request script updated environment variables, but no active environment was selected to save them to.");
    }
    return requestModel;
  }
  return newRequestModel;
}

Future<RequestModel> handlePostResponseScript(
  RequestModel requestModel,
  EnvironmentModel? originalEnvironmentModel,
  void Function(EnvironmentModel, List<EnvironmentVariableModel>)? updateEnv,
) async {
  final scriptResult = await executePostResponseScript(
    currentRequestModel: requestModel,
    activeEnvironment: originalEnvironmentModel?.toJson() ?? {},
  );

  final newRequestModel =
      requestModel.copyWith(httpResponseModel: scriptResult.updatedResponse);

  if (originalEnvironmentModel != null) {
    final updatedEnvironmentMap = scriptResult.updatedEnvironment;

    final List<EnvironmentVariableModel> newValues = [];
    final Map<String, dynamic> mutableUpdatedEnv =
        Map.from(updatedEnvironmentMap);

    for (final originalVariable in originalEnvironmentModel.values) {
      if (mutableUpdatedEnv.containsKey(originalVariable.key)) {
        final dynamic newValue = mutableUpdatedEnv[originalVariable.key];
        newValues.add(
          originalVariable.copyWith(
            value: newValue == null ? '' : newValue.toString(),
            enabled: true,
          ),
        );

        mutableUpdatedEnv.remove(originalVariable.key);
      } else {
        // Variable was removed by the script (unset/clear), don't add it to newValues.
        // Alternatively, you could keep it but set enabled = false:
        // newValues.add(originalVariable.copyWith(enabled: false));
      }
    }

    for (final entry in mutableUpdatedEnv.entries) {
      final dynamic newValue = entry.value;
      newValues.add(
        EnvironmentVariableModel(
          key: entry.key,
          value: newValue == null ? '' : newValue.toString(),
          enabled: true,
          type: EnvironmentVariableType.variable,
        ),
      );
    }
    updateEnv?.call(originalEnvironmentModel, newValues);
  } else {
    debugPrint(
        "Skipped environment update as originalEnvironmentModel was null.");
    if (scriptResult.updatedEnvironment.isNotEmpty) {
      debugPrint(
          "Warning: Post-response script updated environment variables, but no active environment was selected to save them to.");
    }
    return requestModel;
  }
  return newRequestModel;
}
