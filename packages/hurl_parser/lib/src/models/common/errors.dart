
/// Error class for parse failures
/// In future need to implement isRecoverable flag
/// And a way to recover from errors
class ParseError {
  final String message;
  final int position;
  final String source;

  ParseError({
    required this.message,
    required this.position,
    required this.source,
  });

  /// Get the line and column number of the error
  (int, int) get location {
    final lines = source.substring(0, position).split('\n');
    final line = lines.length;
    final column = lines.last.length + 1;
    return (line, column);
  }

  @override
  String toString() {
    final (line, column) = location;
    return 'Parse error at line $line, column $column: $message';
  }
}
