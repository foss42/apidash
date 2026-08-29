import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class CellField extends StatefulWidget {
  const CellField({
    super.key,
    required this.keyId,
    this.initialValue,
    this.hintText,
    this.onChanged,
    this.colorScheme,
  });

  final String keyId;
  final String? initialValue;
  final String? hintText;
  final void Function(String)? onChanged;
  final ColorScheme? colorScheme;

  @override
  State<CellField> createState() => _CellFieldState();
}

class _CellFieldState extends State<CellField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CellField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null &&
        controller.text != widget.initialValue) {
      final currentSelection = controller.selection;
      controller.text = widget.initialValue!;
      if (currentSelection.baseOffset <= controller.text.length) {
        controller.selection = currentSelection;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ADOutlinedTextField(
      key: ValueKey(widget.keyId),
      keyId: widget.keyId,
      controller: controller,
      hintText: widget.hintText,
      hintTextFontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
      onChanged: widget.onChanged,
      colorScheme: widget.colorScheme,
    );
  }
}
