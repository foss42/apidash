import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/js_runtime/app_js_runtime.dart';
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
  late final AppJsRuntime _runtime;
  String? _currentRequestId;

  void _initialize() {
    if (state.initialized) return;
    _runtime = getAppJavascriptRuntime();
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

  AppJsEvalResult evaluate(String code) {
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
      return res;
    } on PlatformException catch (e) {
      final msg = 'Platform ERROR: ${e.details}';
      state = state.copyWith(lastError: msg);
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
    required String requestId,
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
      _currentRequestId = requestId;
      final term = ref.read(terminalStateProvider.notifier);
      final res = _runtime.evaluate(fullScript);
      state = state.copyWith(
        executedScriptCount: state.executedScriptCount + 1,
        lastError: res.isError ? res.stringResult : state.lastError,
      );
      if (res.isError) {
        term.logJs(
            level: 'error',
            args: ['Pre-request script error', res.stringResult],
            context: 'preRequest',
            contextRequestId: requestId);
      } else if (res.stringResult.isNotEmpty) {
        final decoded = jsonDecode(res.stringResult);
        if (decoded is Map<String, dynamic>) {
          if (decoded['request'] is Map) {
            try {
              resultingRequest = HttpRequestModel.fromJson(
                Map<String, Object?>.from(decoded['request'] as Map),
              );
            } catch (e) {
              term.logJs(
                  level: 'error',
                  args: ['Deserialize modified request failed', e.toString()],
                  context: 'preRequest',
                  contextRequestId: requestId);
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
      ref.read(terminalStateProvider.notifier).logJs(
          level: 'error',
          args: [msg],
          context: 'preRequest',
          contextRequestId: requestId);
    } finally {
      _currentRequestId = null;
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
    required String requestId,
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
      _currentRequestId = requestId;
      final term = ref.read(terminalStateProvider.notifier);
      final res = _runtime.evaluate(fullScript);
      state = state.copyWith(
        executedScriptCount: state.executedScriptCount + 1,
        lastError: res.isError ? res.stringResult : state.lastError,
      );
      if (res.isError) {
        term.logJs(
            level: 'error',
            args: ['Post-response script error', res.stringResult],
            context: 'postResponse',
            contextRequestId: requestId);
      } else if (res.stringResult.isNotEmpty) {
        final decoded = jsonDecode(res.stringResult);
        if (decoded is Map<String, dynamic>) {
          if (decoded['response'] is Map) {
            try {
              final raw = Map<String, Object?>.from(decoded['response'] as Map);
              final sanitized = _sanitizeResponseJson(raw);
              resultingResponse = HttpResponseModel.fromJson(sanitized);
            } catch (e) {
              term.logJs(
                  level: 'error',
                  args: ['Deserialize modified response failed', e.toString()],
                  context: 'postResponse',
                  contextRequestId: requestId);
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
      ref.read(terminalStateProvider.notifier).logJs(
          level: 'error',
          args: [msg],
          context: 'postResponse',
          contextRequestId: requestId);
    } finally {
      _currentRequestId = null;
    }
    return (
      updatedResponse: resultingResponse,
      updatedEnvironment: resultingEnvironment,
    );
  }

  Future<RequestModel> handlePreRequestScript(
    RequestModel requestModel,
    EnvironmentModel? originalEnvironmentModel,
    void Function(EnvironmentModel, List<EnvironmentVariableModel>)? updateEnv,
  ) async {
    final scriptResult = await executePreRequestScript(
      currentRequestModel: requestModel,
      activeEnvironment: originalEnvironmentModel?.toJson() ?? {},
      requestId: requestModel.id,
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
        final term = ref.read(terminalStateProvider.notifier);
        final msg =
            'Pre-request script updated environment variables, but no active environment was selected to save them to.';
        state = state.copyWith(lastError: msg);
        term.logJs(
          level: 'warn',
          args: [msg],
          context: 'preRequest',
          contextRequestId: requestModel.id,
        );
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
      requestId: requestModel.id,
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
        final term = ref.read(terminalStateProvider.notifier);
        final msg =
            'Post-response script updated environment variables, but no active environment was selected to save them to.';
        state = state.copyWith(lastError: msg);
        term.logJs(
          level: 'warn',
          args: [msg],
          context: 'postResponse',
          contextRequestId: requestModel.id,
        );
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
    final term = ref.read(terminalStateProvider.notifier);
    try {
      List<String> argList = const <String>[];
      if (args is List) {
        argList = args.map((e) => e.toString()).toList();
      } else if (args is String) {
        // Try to parse JSON-stringified array from JS
        try {
          final decoded = jsonDecode(args);
          if (decoded is List) {
            argList = decoded.map((e) => e?.toString() ?? '').toList();
          } else {
            argList = [args];
          }
        } catch (_) {
          argList = [args];
        }
      } else {
        argList = [args.toString()];
      }
      term.logJs(
          level: level, args: argList, contextRequestId: _currentRequestId);
    } catch (e) {
      term.logSystem(
          category: 'provider',
          message:
              '[JS ${level.toUpperCase()} HANDLER ERROR]: $args, Error: $e');
    }
  }

  void _handleFatal(dynamic args) {
    final term = ref.read(terminalStateProvider.notifier);
    try {
      if (args is Map<String, dynamic>) {
        final message = args['message']?.toString() ?? 'Unknown fatal error';
        final error = args['error']?.toString();
        final stack = args['stack']?.toString();
        term.logJs(
          level: 'fatal',
          args: [if (error != null) error, message],
          stack: stack,
          context: 'global',
          contextRequestId: _currentRequestId,
        );
      } else {
        term.logJs(
            level: 'fatal',
            args: ['Malformed fatal payload', '$args'],
            context: 'global',
            contextRequestId: _currentRequestId);
      }
    } catch (e) {
      term.logSystem(
          category: 'provider',
          message: '[JS FATAL ERROR decoding error]: $args, Error: $e');
    }
  }
}

// Helper to properly escape strings for JS embedding
String jsEscapeString(String s) => jsonEncode(s);

Map<String, Object?> _sanitizeResponseJson(Map<String, Object?> input) {
  final out = Map<String, Object?>.from(input);
  // Ensure headers maps are <String,String>
  if (out['headers'] is Map) {
    final m = Map<String, String>.fromEntries(
      (out['headers'] as Map)
          .entries
          .map((e) => MapEntry(e.key.toString(), e.value?.toString() ?? '')),
    );
    out['headers'] = m;
  }
  if (out['requestHeaders'] is Map) {
    final m = Map<String, String>.fromEntries(
      (out['requestHeaders'] as Map)
          .entries
          .map((e) => MapEntry(e.key.toString(), e.value?.toString() ?? '')),
    );
    out['requestHeaders'] = m;
  }
  // Ensure bodyBytes is List<int>
  if (out['bodyBytes'] is List) {
    out['bodyBytes'] = (out['bodyBytes'] as List)
        .where((e) => e != null)
        .map((e) => (e as num).toInt())
        .toList();
  }
  // Ensure sseOutput is List<String>
  if (out['sseOutput'] is List) {
    out['sseOutput'] = (out['sseOutput'] as List)
        .where((e) => e != null)
        .map((e) => e.toString())
        .toList();
  }
  // Ensure time is int microseconds if provided as number
  if (out['time'] != null && out['time'] is! int) {
    final t = out['time'];
    if (t is num) out['time'] = t.toInt();
  }
  // Body should be string (keep as-is if null)
  if (out['body'] != null && out['body'] is! String) {
    out['body'] = out['body'].toString();
  }
  return out;
}
