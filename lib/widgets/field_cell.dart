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
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? "");
  }

  @override
  void didUpdateWidget(covariant CellField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newValue = widget.initialValue ?? "";
    if (_controller.text != newValue) {
      _controller.text = newValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ADOutlinedTextField(
      keyId: widget.keyId,
      controller: _controller,
      hintText: widget.hintText,
      hintTextFontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
      onChanged: widget.onChanged,
      colorScheme: widget.colorScheme,
    );
  }
}
