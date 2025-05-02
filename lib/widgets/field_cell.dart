import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class CellField extends StatelessWidget {
  const CellField({
    super.key,
    required this.keyId,
    this.initialValue,
    this.hintText,
    this.onChanged,
    this.colorScheme,
    this.onOverlayToggle,
  });

  final String keyId;
  final String? initialValue;
  final String? hintText;
  final void Function(String)? onChanged;
  final ColorScheme? colorScheme;
  final void Function(
    bool,
    GlobalKey<State<StatefulWidget>>,
    String,
    TextStyle,
    ColorScheme,
    FocusNode,
    TextEditingController,
    InputDecoration,
  )? onOverlayToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ADOutlinedTextField(
        keyId: keyId,
        initialValue: initialValue,
        hintText: hintText,
        hintTextFontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
        onChanged: onChanged,
        onOverlayToggle: onOverlayToggle,
        colorScheme: colorScheme,
        isDense: true,
      ),
    );
  }
}