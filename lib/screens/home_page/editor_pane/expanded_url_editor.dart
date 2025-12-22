import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/env_trigger_field.dart';

class ExpandedURLEditor extends StatefulWidget {
  const ExpandedURLEditor({
    super.key,
    required this.selectedId,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
  });

  final String selectedId;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  @override
  State<ExpandedURLEditor> createState() => _ExpandedURLEditorState();
}

class _ExpandedURLEditorState extends State<ExpandedURLEditor> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _moveCursorToNextSeparator() {
    final text = _controller.text;
    final currentPos = _controller.selection.baseOffset;
    if (currentPos < 0 || currentPos >= text.length) return;

    final separators = RegExp(r'[:/.,?&=-_]');
    
    int nextPos = -1;
    for (int i = currentPos + 1; i < text.length; i++) {
      if (separators.hasMatch(text[i])) {
        nextPos = i;
        break;
      }
    }

    if (nextPos != -1) {
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: nextPos));
    } else {
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: text.length));
    }
    _focusNode.requestFocus();
  }

  void _moveCursorToPreviousSeparator() {
    final text = _controller.text;
    final currentPos = _controller.selection.baseOffset;
    if (currentPos <= 0) return;

    final separators = RegExp(r'[:/.,?&=-_]');
    
    int prevPos = -1;
    for (int i = currentPos - 1; i >= 0; i--) {
      if (separators.hasMatch(text[i])) {
        prevPos = i;
        break;
      }
    }

    if (prevPos != -1) {
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: prevPos));
    } else {
      _controller.selection = TextSelection.fromPosition(const TextPosition(offset: 0));
    }
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important for Dialog
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit URL',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    widget.onFieldSubmitted?.call(_controller.text);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
            const SizedBox(height: 16),
             ConstrainedBox(
               constraints: BoxConstraints(
                 maxHeight: MediaQuery.of(context).size.height * 0.6,
               ),
               child: SingleChildScrollView(
                 child: EnvironmentTriggerField(
                  keyId: "expanded-url-${widget.selectedId}",
                  controller: _controller,
                  focusNode: _focusNode,
                  style: kCodeStyle.copyWith(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: kHintTextUrlCard,
                    hintStyle: kCodeStyle.copyWith(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: widget.onChanged,
                  onFieldSubmitted: (val) {
                    widget.onFieldSubmitted?.call(val);
                    Navigator.of(context).pop();
                  },
                  optionsWidthFactor: 1,
                  maxLines: null, // Allow unlimited lines (wrapping)
                  minLines: 3,    // Minimum height
                             ),
               ),
             ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton.filledTonal(
                  onPressed: _moveCursorToPreviousSeparator,
                  icon: const Icon(Icons.keyboard_arrow_left),
                  tooltip: 'Previous Separator',
                ),
                IconButton.filledTonal(
                  onPressed: _moveCursorToNextSeparator,
                  icon: const Icon(Icons.keyboard_arrow_right),
                  tooltip: 'Next Separator',
                ),
                IconButton.filledTonal(
                  onPressed: () {
                     Clipboard.setData(ClipboardData(text: _controller.text));
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('Copied to clipboard')),
                     );
                  },
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy',
                ),
                IconButton.filledTonal(
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                  },
                  icon: const Icon(Icons.clear),
                  tooltip: 'Clear',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
