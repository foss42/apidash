import 'package:flutter/material.dart';
import 'autocomplete_query.dart';
import 'autocomplete_trigger.dart';

class AutocompleteNoTrigger extends AutocompleteTrigger {
  /// Creates a [AutocompleteNoTrigger] which can be used to trigger
  /// suggestions without a trigger.
  const AutocompleteNoTrigger({
    required super.optionsViewBuilder,
    super.minimumRequiredCharacters = 0,
  }) : super(
          trigger: '',
          triggerEnd: '',
          triggerOnlyAtStart: false,
          triggerOnlyAfterSpace: false,
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AutocompleteNoTrigger &&
          runtimeType == other.runtimeType &&
          optionsViewBuilder == other.optionsViewBuilder &&
          minimumRequiredCharacters == other.minimumRequiredCharacters;

  @override
  int get hashCode =>
      optionsViewBuilder.hashCode ^ minimumRequiredCharacters.hashCode;

  /// Returns the [AutocompleteQuery] for the current text field value.
  @override
  AutocompleteQuery? invokingTrigger(TextEditingValue textEditingValue) {
    final text = textEditingValue.text;
    final selection = textEditingValue.selection;

    if (text.length < minimumRequiredCharacters) return null;

    return AutocompleteQuery(
      query: text,
      selection: selection,
    );
  }
}
