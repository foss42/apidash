import 'dart:convert';

class JsonUtils {
  static (int line, int col) getLineCol(String text, int offset) {
    if (offset < 0 || offset > text.length) return (1, 1);
    final before = text.substring(0, offset);
    final lines = before.split('\n');
    return (lines.length, lines.last.length + 1);
  }

  static (String?, int?, int?) findDuplicateKeys(String text) {
    // A simplified parser to detect duplicate keys in JSON objects.
    
    List<Set<String>> scopeStack = []; // Stack of KeySets for objects
    bool inString = false;
    // We only care about keys in Objects ({}).
    
    // Scanner:
    int i = 0;
    List<bool> isObjectStack = []; // true if {}, false if []
    
    // Initial scope (root)
    if (text.trim().startsWith('{')) {
        scopeStack.add({});
        isObjectStack.add(true);
    }
    
    String? lastString;
    int? lastStringStart; 
    StringBuffer currentString = StringBuffer();
    
    while (i < text.length) {
      String char = text[i];
      
      if (inString) {
        if (char == '\\') {
          i++; // Skip escaped char
        } else if (char == '"') {
          inString = false;
          lastString = currentString.toString();
          // Offset of the start of this string key is calculated roughly or tracked?
          // We can track lastStringStart when we see opening quote.
          currentString.clear();
        } else {
          currentString.write(char);
        }
      } else {
        // Not in string
        if (char == '"') {
          inString = true;
          lastStringStart = i; // capture start of string
          currentString.clear();
        } else if (char == '{') {
          scopeStack.add({});
          isObjectStack.add(true);
        } else if (char == '}') {
          if (scopeStack.isNotEmpty) scopeStack.removeLast();
          if (isObjectStack.isNotEmpty) isObjectStack.removeLast();
        } else if (char == '[') {
           scopeStack.add({}); 
           isObjectStack.add(false);
        } else if (char == ']') {
           if (scopeStack.isNotEmpty) scopeStack.removeLast();
           if (isObjectStack.isNotEmpty) isObjectStack.removeLast();
        } else if (char == ':') {
          // The last string was a key, IF we are in an object
          if (isObjectStack.isNotEmpty && isObjectStack.last && lastString != null) {
            final currentScope = scopeStack.last;
            if (currentScope.contains(lastString)) {
              // Length = string length + 2 (quotes)
              return ("Duplicate key '$lastString' found", lastStringStart, lastString!.length + 2);
            }
            currentScope.add(lastString);
            lastString = null; // Consumed
          }
        } else if (char == ',') {
           // Value separator
        }
      }
      i++;
    }
    
    return (null, null, null);
  }
}

