import 'package:flutter/material.dart';
import 'package:multi_trigger_autocomplete_plus/src/autocomplete_query.dart';

/// The type of the [AutocompleteTrigger] callback which returns a [Widget] that
/// displays the specified [options].
typedef AutocompleteTriggerOptionsViewBuilder = Widget Function(
  BuildContext context,
  AutocompleteQuery autocompleteQuery,
  TextEditingController textEditingController,
);

class AutocompleteTrigger {
  /// Creates a [AutocompleteTrigger] which can be used to trigger
  /// autocomplete suggestions.
  const AutocompleteTrigger({
    required this.trigger,
    this.triggerEnd = ' ',
    required this.optionsViewBuilder,
    this.triggerOnlyAtStart = false,
    this.triggerOnlyAfterSpace = true,
    this.minimumRequiredCharacters = 0,
  });

  /// The trigger character.
  ///
  /// eg. '@', '#', ':'
  final String trigger;

  /// The trigger end character.
  /// This is used to determine when the trigger ends.
  /// By default, it's a space.
  final String triggerEnd;

  /// Whether the [trigger] should only be recognised at the start of the input.
  final bool triggerOnlyAtStart;

  /// Whether the [trigger] should only be recognised after a space.
  final bool triggerOnlyAfterSpace;

  /// The minimum required characters for the [trigger] to start recognising
  /// a autocomplete options.
  final int minimumRequiredCharacters;

  /// Builds the selectable options widgets from a list of options objects.
  ///
  /// The options are displayed floating above or below the field using a
  /// [PortalTarget] inside of an [Portal].
  final AutocompleteTriggerOptionsViewBuilder optionsViewBuilder;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AutocompleteTrigger &&
          runtimeType == other.runtimeType &&
          trigger == other.trigger &&
          triggerEnd == other.triggerEnd &&
          triggerOnlyAtStart == other.triggerOnlyAtStart &&
          triggerOnlyAfterSpace == other.triggerOnlyAfterSpace &&
          minimumRequiredCharacters == other.minimumRequiredCharacters;

  @override
  int get hashCode =>
      trigger.hashCode ^
      triggerOnlyAtStart.hashCode ^
      triggerOnlyAfterSpace.hashCode ^
      minimumRequiredCharacters.hashCode;

  /// Checks if the user is invoking the recognising [trigger] and returns
  /// the autocomplete query if so.
  AutocompleteQuery? invokingTrigger(TextEditingValue textEditingValue) {
    final text = textEditingValue.text;
    final selection = textEditingValue.selection;

    // If the selection is invalid, then it's not a trigger.
    if (!selection.isValid) return null;
    final cursorPosition = selection.baseOffset;

    // Find the first [trigger] location before the input cursor.
    final firstTriggerIndexBeforeCursor =
        text.substring(0, cursorPosition).lastIndexOf(trigger);

    // If the [trigger] is not found before the cursor, then it's not a trigger.
    if (firstTriggerIndexBeforeCursor == -1) return null;

    // If the [trigger] is found before the cursor, but the [trigger] is only
    // recognised at the start of the input, then it's not a trigger.
    if (triggerOnlyAtStart && firstTriggerIndexBeforeCursor != 0) {
      return null;
    }

    // Only show typing suggestions after a space, new line or at the start of the input.
    // valid examples: "@user", "Hello @user", "Hello\n@user"
    // invalid examples: "Hello@user"
    final textBeforeTrigger = text.substring(0, firstTriggerIndexBeforeCursor);
    if (triggerOnlyAfterSpace &&
        textBeforeTrigger.isNotEmpty &&
        !(textBeforeTrigger.endsWith(triggerEnd) ||
            textBeforeTrigger.endsWith('\n'))) {
      return null;
    }

    // The suggestion range. Protect against invalid ranges.
    final suggestionStart = firstTriggerIndexBeforeCursor + trigger.length;
    final suggestionEnd = cursorPosition;
    if (suggestionStart > suggestionEnd) return null;

    // Fetch the suggestion text. The suggestions can't have spaces/triggerEnd.
    // valid example: "@luke_skywa..."
    // invalid example: "@luke skywa..."
    final suggestionText = text.substring(suggestionStart, suggestionEnd);
    if (suggestionText.contains(triggerEnd)) return null;

    // A minimum number of characters can be provided to only show
    // suggestions after the customer has input enough characters.
    if (suggestionText.length < minimumRequiredCharacters) return null;

    return AutocompleteQuery(
      query: suggestionText,
      selection: TextSelection(
        baseOffset: suggestionStart,
        extentOffset: suggestionEnd,
      ),
    );
  }
}
