import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';

class CellField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    return ADOutlinedTextField(
      key: ValueKey('$keyId-$initialValue'),
      keyId: keyId,
      initialValue: initialValue,
      hintText: hintText,
      hintTextFontSize: (Theme.of(context).textTheme.bodySmall?.fontSize ?? 12) * ds.scaleFactor,
      onChanged: onChanged,
      colorScheme: colorScheme,
    );
  }
}
