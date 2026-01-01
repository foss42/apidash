import 'package:flutter/foundation.dart';
import 'app_js_runtime.dart';

class AppJsRuntimeWeb implements AppJsRuntime {
  AppJsRuntimeWeb() {
    debugPrint('AppJsRuntimeWeb initialized (limited functionality)');
  }

  @override
  AppJsEvalResult evaluate(String code) {
    // For now, we return a success with empty result or logs to avoid breaking flows.
    // If we want real web JS execution, we would need to use dart:js_interop,
    // but the goal here is to "gracefully handle" failure.
    return AppJsEvalResult(
      '{"status": "ok", "message": "JS Runtime not fully supported on Web yet"}',
    );
  }

  @override
  void onMessage(String channel, void Function(dynamic args) callback) {
    // No-op for web stub
  }

  @override
  void dispose() {
    // No-op
  }
}

AppJsRuntime getAppJavascriptRuntime() {
  return AppJsRuntimeWeb();
}
