import 'dart:convert';

/// The result of evaluating a JSON watch expression against one message.
class JsonWatchResult {
  const JsonWatchResult._({this.value, required this.found, this.error});

  const JsonWatchResult.found(Object? value)
    : this._(value: value, found: true);

  const JsonWatchResult.notFound() : this._(found: false);

  const JsonWatchResult.invalid(String error)
    : this._(found: false, error: error);

  final Object? value;
  final bool found;
  final String? error;

  String get displayValue {
    final currentValue = value;
    if (currentValue is String) return currentValue;
    return jsonEncode(currentValue);
  }
}

/// Validates the key or JSONPath syntax accepted by [extractJsonWatchValue].
String? validateJsonWatchExpression(String expression) {
  try {
    _JsonWatchExpression.parse(expression);
    return null;
  } on FormatException catch (error) {
    return error.message;
  }
}

/// Extracts a watched value from a JSON WebSocket [payload].
///
/// A plain key such as `price` searches recursively for matching keys.
/// JSONPath expressions support root (`$`), child (`.name`), bracket-key
/// (`['name']`), array-index (`[0]`), wildcard (`[*]`), and recursive child
/// (`..name`) selectors. Multiple matches are returned as a list.
JsonWatchResult extractJsonWatchValue(String payload, String expression) {
  final _JsonWatchExpression parsedExpression;
  try {
    parsedExpression = _JsonWatchExpression.parse(expression);
  } on FormatException catch (error) {
    return JsonWatchResult.invalid(error.message);
  }

  final Object? decoded;
  try {
    decoded = jsonDecode(payload);
  } on FormatException {
    return const JsonWatchResult.invalid('Message is not valid JSON');
  }

  final values = parsedExpression.evaluate(decoded);
  if (values.isEmpty) return const JsonWatchResult.notFound();
  if (values.length == 1) return JsonWatchResult.found(values.single);
  return JsonWatchResult.found(values);
}

enum _JsonWatchTokenType { key, arrayIndex, wildcard, recursiveKey }

class _JsonWatchToken {
  const _JsonWatchToken(this.type, this.value);

  final _JsonWatchTokenType type;
  final Object? value;
}

class _JsonWatchExpression {
  const _JsonWatchExpression(this.tokens);

  final List<_JsonWatchToken> tokens;

  static _JsonWatchExpression parse(String source) {
    final expression = source.trim();
    if (expression.isEmpty) {
      throw const FormatException('Enter a key or JSONPath');
    }

    final hasPathSyntax =
        expression.startsWith(r'$') ||
        expression.contains('.') ||
        expression.contains('[') ||
        expression.contains(']');
    if (!hasPathSyntax) {
      return _JsonWatchExpression([
        _JsonWatchToken(_JsonWatchTokenType.recursiveKey, expression),
      ]);
    }

    final tokens = <_JsonWatchToken>[];
    var index = expression.startsWith(r'$') ? 1 : 0;

    while (index < expression.length) {
      if (expression[index] == '.') {
        final recursive =
            index + 1 < expression.length && expression[index + 1] == '.';
        index += recursive ? 2 : 1;
        final parsedKey = _readKey(expression, index);
        if (parsedKey.$1.isEmpty) {
          throw const FormatException('Expected a key after "."');
        }
        tokens.add(
          _JsonWatchToken(
            recursive
                ? _JsonWatchTokenType.recursiveKey
                : _JsonWatchTokenType.key,
            parsedKey.$1,
          ),
        );
        index = parsedKey.$2;
        continue;
      }

      if (expression[index] == '[') {
        final closeIndex = _findBracketEnd(expression, index);
        if (closeIndex == -1) {
          throw const FormatException('Missing closing "]"');
        }
        final content = expression.substring(index + 1, closeIndex).trim();
        if (content == '*') {
          tokens.add(const _JsonWatchToken(_JsonWatchTokenType.wildcard, null));
        } else if (RegExp(r'^\d+$').hasMatch(content)) {
          tokens.add(
            _JsonWatchToken(_JsonWatchTokenType.arrayIndex, int.parse(content)),
          );
        } else {
          final key = _parseBracketKey(content);
          tokens.add(_JsonWatchToken(_JsonWatchTokenType.key, key));
        }
        index = closeIndex + 1;
        continue;
      }

      final parsedKey = _readKey(expression, index);
      if (parsedKey.$1.isEmpty) {
        throw FormatException(
          'Unexpected character "${expression[index]}" at position $index',
        );
      }
      tokens.add(_JsonWatchToken(_JsonWatchTokenType.key, parsedKey.$1));
      index = parsedKey.$2;
    }

    return _JsonWatchExpression(tokens);
  }

  List<Object?> evaluate(Object? root) {
    var currentValues = <Object?>[root];
    for (final token in tokens) {
      final nextValues = <Object?>[];
      for (final currentValue in currentValues) {
        switch (token.type) {
          case _JsonWatchTokenType.key:
            if (currentValue is Map && currentValue.containsKey(token.value)) {
              nextValues.add(currentValue[token.value]);
            }
          case _JsonWatchTokenType.arrayIndex:
            final index = token.value! as int;
            if (currentValue is List && index < currentValue.length) {
              nextValues.add(currentValue[index]);
            }
          case _JsonWatchTokenType.wildcard:
            if (currentValue is List) {
              nextValues.addAll(currentValue);
            } else if (currentValue is Map) {
              nextValues.addAll(currentValue.values);
            }
          case _JsonWatchTokenType.recursiveKey:
            _findRecursiveValues(
              currentValue,
              token.value! as String,
              nextValues,
            );
        }
      }
      currentValues = nextValues;
      if (currentValues.isEmpty) break;
    }
    return currentValues;
  }
}

(String, int) _readKey(String expression, int start) {
  var index = start;
  while (index < expression.length &&
      expression[index] != '.' &&
      expression[index] != '[' &&
      expression[index] != ']') {
    index++;
  }
  return (expression.substring(start, index).trim(), index);
}

int _findBracketEnd(String expression, int start) {
  String? quote;
  var escaped = false;
  for (var index = start + 1; index < expression.length; index++) {
    final character = expression[index];
    if (escaped) {
      escaped = false;
      continue;
    }
    if (character == r'\') {
      escaped = true;
      continue;
    }
    if (quote != null) {
      if (character == quote) quote = null;
      continue;
    }
    if (character == '"' || character == "'") {
      quote = character;
    } else if (character == ']') {
      return index;
    }
  }
  return -1;
}

String _parseBracketKey(String content) {
  if (content.length < 2 ||
      !((content.startsWith('"') && content.endsWith('"')) ||
          (content.startsWith("'") && content.endsWith("'")))) {
    throw const FormatException(
      'Bracket keys must be quoted, for example [\'price\']',
    );
  }

  if (content.startsWith('"')) {
    try {
      return jsonDecode(content) as String;
    } on FormatException {
      throw const FormatException('Invalid quoted bracket key');
    }
  }

  return content
      .substring(1, content.length - 1)
      .replaceAll(r"\'", "'")
      .replaceAll(r'\\', r'\');
}

void _findRecursiveValues(Object? value, String key, List<Object?> matches) {
  if (value is Map) {
    if (value.containsKey(key)) matches.add(value[key]);
    for (final child in value.values) {
      _findRecursiveValues(child, key, matches);
    }
  } else if (value is List) {
    for (final child in value) {
      _findRecursiveValues(child, key, matches);
    }
  }
}
