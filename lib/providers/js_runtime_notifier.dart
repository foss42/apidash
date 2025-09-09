// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:developer';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import '../providers/terminal_providers.dart';

class JsRuntimeState {
  const JsRuntimeState({
    this.initialized = false,
    this.lastError,
    this.executedScriptCount = 0,
  });

  final bool initialized;
  final String? lastError;
  final int executedScriptCount;

  JsRuntimeState copyWith({
    bool? initialized,
    String? lastError,
    int? executedScriptCount,
  }) =>
      JsRuntimeState(
        initialized: initialized ?? this.initialized,
        lastError: lastError ?? this.lastError,
        executedScriptCount: executedScriptCount ?? this.executedScriptCount,
      );
}

final jsRuntimeNotifierProvider =
    StateNotifierProvider<JsRuntimeNotifier, JsRuntimeState>((ref) {
  final notifier = JsRuntimeNotifier(ref);
  notifier._initialize();
  return notifier;
});

class JsRuntimeNotifier extends StateNotifier<JsRuntimeState> {
  JsRuntimeNotifier(this.ref) : super(const JsRuntimeState());

  final Ref ref;
  late final JavascriptRuntime _runtime;

  void _initialize() {
    if (state.initialized) return;
    _runtime = getJavascriptRuntime();
    _setupJsBridge();
    state = state.copyWith(initialized: true);
  }

  @override
  void dispose() {
    // Guard: runtime may already be disposed by underlying provider disposal
    try {
      if (state.initialized) {
        _runtime.dispose();
      }
    } catch (_) {
      // swallow disposal errors
    }
    super.dispose();
  }

  JsEvalResult evaluate(String code) {
    // If disposed, prevent usage
    if (!mounted) {
      throw StateError('JsRuntimeNotifier used after dispose');
    }
    try {
      final res = _runtime.evaluate(code);
      state = state.copyWith(
        executedScriptCount: state.executedScriptCount + 1,
        lastError: res.isError ? res.stringResult : state.lastError,
      );
      log(res.stringResult);
      return res;
    } on PlatformException catch (e) {
      final msg = 'Platform ERROR: ${e.details}';
      state = state.copyWith(lastError: msg);
      log(msg);
      rethrow;
    }
  }

  Future<
      ({
        HttpRequestModel updatedRequest,
        Map<String, dynamic> updatedEnvironment
      })> executePreRequestScript({
    required RequestModel currentRequestModel,
    required Map<String, dynamic> activeEnvironment,
  }) async {
    if ((currentRequestModel.preRequestScript ?? '').trim().isEmpty) {
      return (
        updatedRequest: currentRequestModel.httpRequestModel!,
        updatedEnvironment: activeEnvironment,
      );
    }

    final httpRequest = currentRequestModel.httpRequestModel;
    final userScript = currentRequestModel.preRequestScript;
    final requestJson = jsonEncode(httpRequest?.toJson());
    final environmentJson = jsonEncode(activeEnvironment);
    final dataInjection = '''
  var injectedRequestJson = ${jsEscapeString(requestJson)};
  var injectedEnvironmentJson = ${jsEscapeString(environmentJson)};
  var injectedResponseJson = null; // Not needed for pre-request
  ''';
    final fullScript = '''
  (function() {
    $dataInjection
    $kJSSetupScript
    $userScript
    return JSON.stringify({ request: request, environment: environment });
  })();
  ''';

    HttpRequestModel resultingRequest = httpRequest!;
    Map<String, dynamic> resultingEnvironment = Map.from(activeEnvironment);
    try {
      final res = _runtime.evaluate(fullScript);
      state = state.copyWith(
        executedScriptCount: state.executedScriptCount + 1,
        lastError: res.isError ? res.stringResult : state.lastError,
      );
      if (res.isError) {
        print('Pre-request script execution error: ${res.stringResult}');
      } else if (res.stringResult.isNotEmpty) {
        final decoded = jsonDecode(res.stringResult);
        if (decoded is Map<String, dynamic>) {
          if (decoded['request'] is Map) {
            try {
              resultingRequest = HttpRequestModel.fromJson(
                Map<String, Object?>.from(decoded['request'] as Map),
              );
            } catch (e) {
              print('Error deserializing modified request from script: $e');
            }
          }
          if (decoded['environment'] is Map) {
            resultingEnvironment =
                Map<String, dynamic>.from(decoded['environment'] as Map);
          }
        }
      }
    } catch (e) {
      final msg = 'Dart-level error during pre-request script execution: $e';
      state = state.copyWith(lastError: msg);
      print(msg);
    }
    return (
      updatedRequest: resultingRequest,
      updatedEnvironment: resultingEnvironment,
    );
  }

  Future<
      ({
        HttpResponseModel updatedResponse,
        Map<String, dynamic> updatedEnvironment
      })> executePostResponseScript({
    required RequestModel currentRequestModel,
    required Map<String, dynamic> activeEnvironment,
  }) async {
    if ((currentRequestModel.postRequestScript ?? '').trim().isEmpty) {
      return (
        updatedResponse: currentRequestModel.httpResponseModel!,
        updatedEnvironment: activeEnvironment,
      );
    }

    final httpRequest = currentRequestModel.httpRequestModel; // for future use
    final httpResponse = currentRequestModel.httpResponseModel;
    final userScript = currentRequestModel.postRequestScript;
    final requestJson = jsonEncode(httpRequest?.toJson());
    final responseJson = jsonEncode(httpResponse?.toJson());
    final environmentJson = jsonEncode(activeEnvironment);
    final dataInjection = '''
  var injectedRequestJson = ${jsEscapeString(requestJson)};
  var injectedEnvironmentJson = ${jsEscapeString(environmentJson)};
  var injectedResponseJson = ${jsEscapeString(responseJson)};
  ''';
    final fullScript = '''
  (function() {
    $dataInjection
    $kJSSetupScript
    $userScript
    return JSON.stringify({ response: response, environment: environment });
  })();
  ''';

    HttpResponseModel resultingResponse = httpResponse!;
    Map<String, dynamic> resultingEnvironment = Map.from(activeEnvironment);
    try {
      final res = _runtime.evaluate(fullScript);
      state = state.copyWith(
        executedScriptCount: state.executedScriptCount + 1,
        lastError: res.isError ? res.stringResult : state.lastError,
      );
      if (res.isError) {
        print('Post-response script execution error: ${res.stringResult}');
      } else if (res.stringResult.isNotEmpty) {
        final decoded = jsonDecode(res.stringResult);
        if (decoded is Map<String, dynamic>) {
          if (decoded['response'] is Map) {
            try {
              resultingResponse = HttpResponseModel.fromJson(
                Map<String, Object?>.from(decoded['response'] as Map),
              );
            } catch (e) {
              print('Error deserializing modified response from script: $e');
            }
          }
          if (decoded['environment'] is Map) {
            resultingEnvironment =
                Map<String, dynamic>.from(decoded['environment'] as Map);
          }
        }
      }
    } catch (e) {
      final msg = 'Dart-level error during post-response script execution: $e';
      state = state.copyWith(lastError: msg);
      print(msg);
    }
    return (
      updatedResponse: resultingResponse,
      updatedEnvironment: resultingEnvironment,
    );
  }

  // High-level helpers (migrated from pre_post_script_utils) -----------------

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
      if (scriptResult.updatedEnvironment.isNotEmpty) {
        print(
            'Warning: Pre-request script updated environment variables, but no active environment was selected to save them to.');
        return requestModel;
      }
      return newRequestModel;
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
      activeEnvironment: originalEnvironmentModel?.toJson() ?? {'values': []},
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
      if (scriptResult.updatedEnvironment.isNotEmpty) {
        print(
            'Warning: Post-response script updated environment variables, but no active environment was selected to save them to.');
      }
      return requestModel;
    }
    return newRequestModel;
  }

  void _setupJsBridge() {
    _runtime.onMessage('consoleLog', (args) => _handleConsole('log', args));
    _runtime.onMessage('consoleWarn', (args) => _handleConsole('warn', args));
    _runtime.onMessage('consoleError', (args) => _handleConsole('error', args));
    _runtime.onMessage('fatalError', (args) => _handleFatal(args));
  }

  void _handleConsole(String level, dynamic args) {
    try {
      final term = ref.read(terminalStateProvider.notifier);
      final List<String> argList = (args is List)
          ? args.map((e) => e.toString()).toList()
          : [args.toString()];
      term.logJs(level: level, args: argList);
    } catch (e) {
      print('[JS ${level.toUpperCase()} HANDLER ERROR]: $args, Error: $e');
    }
  }

  void _handleFatal(dynamic args) {
    try {
      final term = ref.read(terminalStateProvider.notifier);
      if (args is Map<String, dynamic>) {
        final message = args['message']?.toString() ?? 'Unknown fatal error';
        final error = args['error']?.toString();
        final stack = args['stack']?.toString();
        term.logJs(
          level: 'fatal',
          args: [if (error != null) error, message],
          stack: stack,
        );
      } else {
        term.logJs(level: 'fatal', args: ['Malformed fatal payload', '$args']);
      }
    } catch (e) {
      print('[JS FATAL ERROR decoding error]: $args, Error: $e');
    }
  }
}

// Helper to properly escape strings for JS embedding
String jsEscapeString(String s) => jsonEncode(s);
