import 'dart:async';

import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/terminal/terminal.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';

class WorkflowStepExecutionResult {
  const WorkflowStepExecutionResult({
    required this.ok,
    this.statusCode,
    this.message,
    this.httpResponseModel,
    this.duration,
    this.apiType,
    this.substitutedRequest,
  });

  final bool ok;
  final int? statusCode;
  final String? message;
  final HttpResponseModel? httpResponseModel;
  final Duration? duration;
  final APIType? apiType;
  final HttpRequestModel? substitutedRequest;
}

Future<WorkflowStepExecutionResult> executeWorkflowRequest({
  required WidgetRef ref,
  required RequestModel requestModel,
  required Map<String, String> scopedVariables,
  String? logLabel,
}) async {
  var executionModel = requestModel.copyWith(
    isWorking: true,
    sendingTime: DateTime.now(),
  );

  final originalEnvironment = ref.read(activeEnvironmentModelProvider);
  if (!executionModel.preRequestScript.isNullOrEmpty()) {
    executionModel = await ref
        .read(jsRuntimeNotifierProvider.notifier)
        .handlePreRequestScript(
          executionModel,
          originalEnvironment,
          (envModel, updatedValues) {
            ref
                .read(environmentsStateNotifierProvider.notifier)
                .updateEnvironment(
                  envModel.id,
                  name: envModel.name,
                  values: updatedValues,
                );
          },
        );
  }

  final envMap = ref.read(availableEnvironmentVariablesStateProvider);
  final activeEnvId = ref.read(activeEnvironmentIdProvider);
  final apiType = executionModel.apiType;
  final defaultUriScheme = ref.read(settingsProvider).defaultUriScheme;
  final noSSL = ref.read(settingsProvider).isSSLDisabled;
  final HttpRequestModel substituted;
  if (apiType == APIType.ai) {
    substituted = substituteHttpRequestModel(
      executionModel.aiRequestModel!.httpRequestModel!,
      envMap,
      activeEnvId,
      additionalVariables: scopedVariables,
    );
  } else {
    substituted = substituteHttpRequestModel(
      executionModel.httpRequestModel!,
      envMap,
      activeEnvId,
      additionalVariables: scopedVariables,
    );
  }

  final terminal = ref.read(terminalStateProvider.notifier);
  final validation = getValidationResult(substituted);
  if (validation != null) {
    terminal.logSystem(
      category: 'validation',
      message: validation,
      level: TerminalLevel.error,
    );
    ref.read(showTerminalBadgeProvider.notifier).state = true;
    return WorkflowStepExecutionResult(
      ok: false,
      message: validation,
    );
  }

  final logId = terminal.startNetwork(
    apiType: executionModel.apiType,
    method: substituted.method,
    url: substituted.url,
    requestId: logLabel ?? executionModel.id,
    requestHeaders: substituted.enabledHeadersMap,
    requestBodyPreview: substituted.body,
    isStreaming: false,
  );

  final stream = await streamHttpRequest(
    executionModel.id,
    apiType,
    substituted,
    defaultUriScheme: defaultUriScheme,
    noSSL: noSSL,
  );

  final completer = Completer<(Response?, Duration?, String?)>();
  StreamSubscription? sub;
  sub = stream.listen(
    (record) {
      if (record == null || completer.isCompleted) {
        return;
      }
      completer.complete((record.$2, record.$3, record.$4));
    },
    onError: (Object error) {
      if (!completer.isCompleted) {
        completer.complete((null, null, 'StreamError: $error'));
      }
    },
    onDone: () {
      if (!completer.isCompleted) {
        completer.complete((null, null, 'No response'));
      }
    },
  );

  final (response, duration, errorMessage) = await completer.future;
  await sub.cancel();

  if (response == null) {
    terminal.failNetwork(logId, errorMessage ?? 'Unknown error');
    return WorkflowStepExecutionResult(
      ok: false,
      message: errorMessage ?? 'Unknown error',
      apiType: executionModel.apiType,
      substitutedRequest: substituted,
    );
  }

  final httpResponseModel = const HttpResponseModel().fromResponse(
    response: response,
    time: duration,
    isStreamingResponse: false,
  );
  terminal.completeNetwork(
    logId,
    statusCode: response.statusCode,
    responseHeaders: response.headers,
    responseBodyPreview: httpResponseModel.body,
    duration: duration,
  );

  final statusCode = response.statusCode;
  return WorkflowStepExecutionResult(
    ok: statusCode >= 200 && statusCode < 400,
    statusCode: statusCode,
    message: kResponseCodeReasons[statusCode],
    httpResponseModel: httpResponseModel,
    duration: duration,
    apiType: executionModel.apiType,
    substitutedRequest: substituted,
  );
}
