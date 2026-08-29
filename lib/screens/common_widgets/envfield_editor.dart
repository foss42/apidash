import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apidash/screens/common_widgets/env_trigger_field.dart';

class EnvTextFieldEditor extends StatefulWidget {
  const EnvTextFieldEditor({
    super.key,
    required this.fieldKey,
    this.onChanged,
    this.initialValue,
    this.readOnly = false,
    this.hintText,
  });

  final String fieldKey;
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final bool readOnly;
  final String? hintText;

  @override
  State<EnvTextFieldEditor> createState() => _EnvTextFieldEditorState();
}

class _EnvTextFieldEditorState extends State<EnvTextFieldEditor> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant EnvTextFieldEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.initialValue ?? '') != _controller.text) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _insertTab() {
    final selection = _controller.selection;
    final text = _controller.text;
    const tabSpaces = '  ';

    final newText = text.replaceRange(
      selection.start,
      selection.end,
      tabSpaces,
    );

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + tabSpaces.length,
      ),
    );

    widget.onChanged?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.tab): _insertTab,
      },
      child: EnvironmentTriggerField(
        key: Key(widget.fieldKey),
        keyId: widget.fieldKey,
        controller: _controller,
        focusNode: _focusNode,
        readOnly: widget.readOnly,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Enter request body',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }
}