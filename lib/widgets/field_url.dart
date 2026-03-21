import 'dart:async';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:flutter/services.dart';

class URLField extends StatefulWidget {
  const URLField({
    super.key,
    required this.selectedId,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.onPastedText,
  });

  final String selectedId;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final Future<bool> Function(String)? onPastedText;

  @override
  State<URLField> createState() => _URLFieldState();
}

class _URLFieldState extends State<URLField> {
  late final TextEditingController _controller;
  late String _lastText;
  int _pendingChangeId = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _lastText = _controller.text;
  }

  @override
  void didUpdateWidget(covariant URLField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextInitialValue = widget.initialValue ?? '';
    if (oldWidget.selectedId != widget.selectedId &&
        _controller.text != nextInitialValue) {
      _controller.value = TextEditingValue(
        text: nextInitialValue,
        selection: TextSelection.collapsed(offset: nextInitialValue.length),
      );
      _lastText = nextInitialValue;
      return;
    }

    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != nextInitialValue) {
      final currentSelection = _controller.selection;
      _controller.text = nextInitialValue;
      if (currentSelection.baseOffset <= _controller.text.length) {
        _controller.selection = currentSelection;
      }
      _lastText = _controller.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      _controller.text == expectedText;

  void _commitTextChange(String value) {
    _lastText = value;
    widget.onChanged?.call(value);
  }

  void _restorePreviousText(String previousText) {
    _controller.value = TextEditingValue(
      text: previousText,
      selection: TextSelection.collapsed(offset: previousText.length),
    );
    _lastText = previousText;
    widget.onChanged?.call(previousText);
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
    return TextFormField(
      key: Key("url-${widget.selectedId}"),
      controller: _controller,
      style: kCodeStyle,
      decoration: InputDecoration(
        hintText: kHintTextUrlCard,
        hintStyle: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        border: InputBorder.none,
      ),
      onChanged: _handleChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
