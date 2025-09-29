class ChatFailure implements Exception {
  final String message;
  final String? code;
  const ChatFailure(this.message, {this.code});

  @override
  String toString() => 'ChatFailure: $message';
}
