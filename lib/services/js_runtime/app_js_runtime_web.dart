import 'package:flutter/foundation.dart';
import 'app_js_runtime.dart';

class AppJsRuntimeWeb implements AppJsRuntime {
  AppJsRuntimeWeb() {
    debugPrint('AppJsRuntimeWeb initialized (limited functionality)');
  }

  @override
  AppJsEvalResult evaluate(String code) {
    return AppJsEvalResult(
      '{"status": "ok", "message": "JS Runtime not fully supported on Web yet"}',
    );
  }

  @override
  void onMessage(String channel, void Function(dynamic args) callback) {}

  @override
  void dispose() {}
}

AppJsRuntime getAppJavascriptRuntime() {
  return AppJsRuntimeWeb();
}
