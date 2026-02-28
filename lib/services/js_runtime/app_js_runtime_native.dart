import 'package:flutter_js/flutter_js.dart' as flutter_js;
import 'app_js_runtime.dart';

class AppJsRuntimeNative implements AppJsRuntime {
  late final flutter_js.JavascriptRuntime _runtime;

  AppJsRuntimeNative() {
    _runtime = flutter_js.getJavascriptRuntime();
  }

  @override
  AppJsEvalResult evaluate(String code) {
    final res = _runtime.evaluate(code);
    return AppJsEvalResult(
      res.stringResult,
      isError: res.isError,
    );
  }

  @override
  void onMessage(String channel, void Function(dynamic args) callback) {
    _runtime.onMessage(channel, callback);
  }

  @override
  void dispose() {
    _runtime.dispose();
  }
}

AppJsRuntime getAppJavascriptRuntime() {
  return AppJsRuntimeNative();
}
