class JsEvalResultAdapter {
  const JsEvalResultAdapter({
    required this.isError,
    required this.stringResult,
  });

  final bool isError;
  final String stringResult;
}

typedef JsMessageHandler = void Function(dynamic args);

class JsRuntimeAdapter {
  JsEvalResultAdapter evaluate(String code) {
    return const JsEvalResultAdapter(
      isError: true,
      stringResult:
          'JavaScript scripting is not supported on web target in this build.',
    );
  }

  void onMessage(String channel, JsMessageHandler handler) {}

  void dispose() {}
}

JsRuntimeAdapter createJsRuntime() => JsRuntimeAdapter();
