export 'app_js_runtime_stub.dart'
    if (dart.library.io) 'app_js_runtime_native.dart'
    if (dart.library.js_interop) 'app_js_runtime_web.dart';

abstract class AppJsRuntime {
  /// Evaluates the given JavaScript code and returns the result.
  AppJsEvalResult evaluate(String code);

  /// Registers a callback for messages sent from JavaScript.
  void onMessage(String channel, void Function(dynamic args) callback);

  /// Disposes the runtime and releases resources.
  void dispose();
}

class AppJsEvalResult {
  final String stringResult;
  final bool isError;

  AppJsEvalResult(this.stringResult, {this.isError = false});

  @override
  String toString() => stringResult;
}

AppJsRuntime getAppJavascriptRuntime() {
  throw UnimplementedError(
      'getAppJavascriptRuntime() has not been implemented.');
}
