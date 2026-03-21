import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'env_regexp_span_builder.dart';
import 'env_trigger_options.dart';

class EnvironmentTriggerField extends StatefulWidget {
  const EnvironmentTriggerField({
    super.key,
    required this.keyId,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.onPastedText,
    this.style,
    this.decoration,
    this.optionsWidthFactor,
    this.autocompleteNoTrigger,
    this.readOnly = false,
    this.obscureText = false,
  }) : assert(
         !(controller != null && initialValue != null),
         'controller and initialValue cannot be simultaneously defined.',
       );

  final String keyId;
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final Future<bool> Function(String)? onPastedText;
  final TextStyle? style;
  final InputDecoration? decoration;
  final double? optionsWidthFactor;
  final AutocompleteNoTrigger? autocompleteNoTrigger;
  final bool readOnly;
  final bool obscureText;

  @override
  State<EnvironmentTriggerField> createState() =>
      EnvironmentTriggerFieldState();
}

class EnvironmentTriggerFieldState extends State<EnvironmentTriggerField> {
  late TextEditingController controller;
  late FocusNode _focusNode;
  late String _lastText;
  late bool _ownsController;
  late bool _ownsFocusNode;
  int _pendingChangeId = 0;

  @override
  void initState() {
    super.initState();
    final initialText = widget.initialValue ?? '';
    _ownsController = widget.controller == null;
    controller = widget.controller ?? _buildController(initialText);
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _lastText = controller.text;
  }

  @override
  void dispose() {
    if (_ownsController) controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EnvironmentTriggerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      if (_ownsFocusNode) {
        _focusNode.dispose();
      }
      _ownsFocusNode = widget.focusNode == null;
      _focusNode = widget.focusNode ?? FocusNode();
    }

    if (oldWidget.keyId != widget.keyId) {
      final initialText = widget.initialValue ?? '';
      if (_ownsController) {
        controller.dispose();
      }
      _ownsController = widget.controller == null;
      controller = widget.controller ?? _buildController(initialText);
      _lastText = controller.text;
    } else if (widget.controller == null &&
        oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null &&
        controller.text != widget.initialValue) {
      // Update controller text only if it differs from current text
      // This preserves cursor position when typing
      final currentSelection = controller.selection;
      controller.text = widget.initialValue!;
      // Restore the selection if it's still valid
      if (currentSelection.baseOffset <= controller.text.length) {
        controller.selection = currentSelection;
      }
      _lastText = controller.text;
    }
  }

  TextEditingController _buildController(String text) =>
      TextEditingController.fromValue(
        TextEditingValue(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        ),
      );

  bool _shouldCheckForPaste(String previousText, String nextText) {
    final trimmedNextText = nextText.trim();
    return widget.onPastedText != null &&
        trimmedNextText != previousText.trim() &&
        trimmedNextText.startsWith('curl ') &&
        nextText.length > previousText.length + 1;
  }

  bool _isCurrentPendingChange(int changeId, String expectedText) =>
      mounted &&
      _pendingChangeId == changeId &&
      controller.text == expectedText;

  void _commitTextChange(String value) {
    _lastText = value;
    widget.onChanged?.call(value);
  }

  void _restorePreviousText(String previousText) {
    controller.value = TextEditingValue(
      text: previousText,
      selection: TextSelection.collapsed(offset: previousText.length),
    );
    _lastText = previousText;
    widget.onChanged?.call(previousText);
  }

  void _handleChanged(String value) {
    final previousText = _lastText;
    final changeId = ++_pendingChangeId;
    if (!_shouldCheckForPaste(previousText, value)) {
      _commitTextChange(value);
      return;
    }
    unawaited(
      _handlePotentialPaste(
        changeId: changeId,
        previousText: previousText,
        nextText: value,
      ),
    );
  }

  Future<void> _handlePotentialPaste({
    required int changeId,
    required String previousText,
    required String nextText,
  }) async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (!_isCurrentPendingChange(changeId, nextText)) return;

      final clipboardText = clipboardData?.text;
      if (clipboardText == null || clipboardText.trim() != nextText.trim()) {
        _commitTextChange(nextText);
        return;
      }

      final handled = await widget.onPastedText!.call(clipboardText);
      if (!_isCurrentPendingChange(changeId, nextText)) return;
      if (!handled) {
        _commitTextChange(nextText);
        return;
      }

      _restorePreviousText(previousText);
    } catch (_) {
      if (_isCurrentPendingChange(changeId, nextText)) {
        _commitTextChange(nextText);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiTriggerAutocomplete(
      key: Key(widget.keyId),
      textEditingController: controller,
      focusNode: _focusNode,
      optionsWidthFactor: widget.optionsWidthFactor ?? 1,
      autocompleteTriggers: [
        if (widget.autocompleteNoTrigger != null) widget.autocompleteNoTrigger!,
        AutocompleteTrigger(
          trigger: '{',
          triggerEnd: "}}",
          triggerOnlyAfterSpace: false,
          optionsViewBuilder: (context, autocompleteQuery, controller) {
            return EnvironmentTriggerOptions(
              query: autocompleteQuery.query,
              onSuggestionTap: (suggestion) {
                final autocomplete = MultiTriggerAutocomplete.of(context);
                autocomplete.acceptAutocompleteOption(
                  '{${suggestion.variable.key}',
                );
                widget.onChanged?.call(controller.text);
              },
            );
          },
        ),
        AutocompleteTrigger(
          trigger: '{{',
          triggerEnd: "}}",
          triggerOnlyAfterSpace: false,
          optionsViewBuilder: (context, autocompleteQuery, controller) {
            return EnvironmentTriggerOptions(
              query: autocompleteQuery.query,
              onSuggestionTap: (suggestion) {
                final autocomplete = MultiTriggerAutocomplete.of(context);
                autocomplete.acceptAutocompleteOption(suggestion.variable.key);
                widget.onChanged?.call(controller.text);
              },
            );
          },
        ),
      ],
      fieldViewBuilder: (context, textEditingController, focusnode) {
        return ExtendedTextField(
          controller: textEditingController,
          focusNode: focusnode,
          decoration: widget.decoration,
          style: widget.style,
          onChanged: _handleChanged,
          onSubmitted: widget.onFieldSubmitted,
          specialTextSpanBuilder: EnvRegExpSpanBuilder(),
          onTapOutside: (event) {
            _focusNode.unfocus();
          },
          readOnly: widget.readOnly,
          obscureText: widget.obscureText,
        );
      },
    );
  }
}
