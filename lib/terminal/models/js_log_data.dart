class JsLogData {
  JsLogData({
    required this.level,
    required this.args,
    this.stack,
    this.context,
    this.contextRequestId,
  });

  final String level; // log | warn | error | fatal
  final List<String> args;
  final String? stack;
  final String? context; // preRequest | postResponse | global
  final String? contextRequestId;
}
