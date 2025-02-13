import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
import 'env_trigger_field.dart';

class EnvCellField extends StatefulWidget {
  const EnvCellField({
    super.key,
    required this.keyId,
    this.initialValue,
    this.hintText,
    this.onChanged,
    this.colorScheme,
    this.autocompleteNoTrigger,
    this.focusNode,
    this.controller,
  }) : assert(
          !(controller != null && initialValue != null),
          'controller and initialValue cannot be simultaneously defined.',
        );

  final String keyId;
  final String? initialValue;
  final String? hintText;
  final void Function(String)? onChanged;
  final ColorScheme? colorScheme;
  final AutocompleteNoTrigger? autocompleteNoTrigger;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  @override
  State<EnvCellField> createState() => _EnvCellFieldState();
}

class _EnvCellFieldState extends State<EnvCellField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController.fromValue(TextEditingValue(
            text: widget.initialValue!,
            selection:
                TextSelection.collapsed(offset: widget.initialValue!.length)));
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EnvCellField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.keyId != widget.keyId) ||
        (oldWidget.initialValue != widget.initialValue)) {
      _controller = widget.controller ??
          TextEditingController.fromValue(TextEditingValue(
              text: widget.initialValue!,
              selection: TextSelection.collapsed(
                  offset: widget.initialValue!.length)));
    }
  }

  @override
  Widget build(BuildContext context) {
    var clrScheme = widget.colorScheme ?? Theme.of(context).colorScheme;
    return EnvironmentTriggerField(
      keyId: widget.keyId,
      controller: _controller,
      focusNode: _focusNode,
      style: kCodeStyle.copyWith(
        color: clrScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintStyle: kCodeStyle.copyWith(
          color: clrScheme.outline.withOpacity(
            kHintOpacity,
          ),
        ),
        hintText: widget.hintText,
        contentPadding: const EdgeInsets.only(bottom: 12),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: clrScheme.primary.withOpacity(
              kHintOpacity,
            ),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: clrScheme.surfaceContainerHighest,
          ),
        ),
      ),
      autocompleteNoTrigger: widget.autocompleteNoTrigger,
      onChanged: widget.onChanged,
    );
  }
}
