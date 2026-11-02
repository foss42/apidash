import 'dart:io';

String interactiveEdit(String prompt, String initialValue) {
  stdout.write('$prompt: ');
  
  // Save state
  final originalEchoMode = stdin.echoMode;
  final originalLineMode = stdin.lineMode;
  
  try {
    stdin.echoMode = false;
    stdin.lineMode = false;

    var buffer = initialValue;
    stdout.write(buffer);

    while (true) {
      final charCode = stdin.readByteSync();
      
      if (charCode == 10 || charCode == 13) { // Enter
        break;
      } else if (charCode == 127 || charCode == 8) { // Backspace
        if (buffer.isNotEmpty) {
          buffer = buffer.substring(0, buffer.length - 1);
          stdout.write('\b \b');
        }
      } else if (charCode >= 32 && charCode <= 126) { // Printable chars
        final char = String.fromCharCode(charCode);
        buffer += char;
        stdout.write(char);
      } else if (charCode == 3) { // Ctrl+C
        exit(130);
      }
    }
    return buffer;
  } finally {
    stdin.echoMode = originalEchoMode;
    stdin.lineMode = originalLineMode;
  }
}
