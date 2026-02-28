import 'package:flutter/material.dart';

class AutocompleteQuery {
  /// Creates a [AutocompleteQuery] with the specified [query] and
  /// [selection].
  const AutocompleteQuery({
    required this.query,
    required this.selection,
  });

  /// The query string.
  final String query;

  /// The selection in the text field.
  final TextSelection selection;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AutocompleteQuery &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          selection == other.selection;

  @override
  int get hashCode => query.hashCode ^ selection.hashCode;
}
