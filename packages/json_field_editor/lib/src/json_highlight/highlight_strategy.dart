import 'package:flutter/material.dart';

abstract class HighlightStrategy {
  final TextStyle? textStyle;

  HighlightStrategy({required this.textStyle});

  bool match(String word);

  TextSpan textSpan(String word);
}

class KeyHighlightStrategy extends HighlightStrategy {
  KeyHighlightStrategy({required super.textStyle});

  @override
  bool match(String word) => RegExp(r'\".*?\"\s*:').hasMatch(word);

  @override
  TextSpan textSpan(String word) => TextSpan(text: word, style: textStyle);
}

class StringHighlightStrategy extends HighlightStrategy {
  StringHighlightStrategy({required super.textStyle});

  @override
  bool match(String word) => RegExp(r'\".*?\"').hasMatch(word);

  @override
  TextSpan textSpan(String word) => TextSpan(text: word, style: textStyle);
}

class NumberHighlightStrategy extends HighlightStrategy {
  NumberHighlightStrategy({required super.textStyle});

  @override
  bool match(String word) => RegExp(r'\s*\b(\d+(\.\d+)?)\b').hasMatch(word);

  @override
  TextSpan textSpan(String word) => TextSpan(text: word, style: textStyle);
}

class BoolHighlightStrategy extends HighlightStrategy {
  BoolHighlightStrategy({required super.textStyle});

  @override
  bool match(String word) => RegExp(r'\b(true|false)\b').hasMatch(word);

  @override
  TextSpan textSpan(String word) => TextSpan(text: word, style: textStyle);
}

class NullHighlightStrategy extends HighlightStrategy {
  NullHighlightStrategy({required super.textStyle});

  @override
  bool match(String word) => RegExp(r'\bnull\b').hasMatch(word);

  @override
  TextSpan textSpan(String word) => TextSpan(text: word, style: textStyle);
}

class SpecialCharHighlightStrategy extends HighlightStrategy {
  SpecialCharHighlightStrategy({required super.textStyle});

  @override
  bool match(String word) => RegExp(r'[{}\[\],:]').hasMatch(word);

  @override
  TextSpan textSpan(String word) => TextSpan(text: word, style: textStyle);
}
