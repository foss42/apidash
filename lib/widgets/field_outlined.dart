import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class OutlinedField extends StatelessWidget {
  const OutlinedField({
    super.key,
    this.keyId,
    this.initialValue,
    this.hintText,
    this.onChanged,
    this.colorScheme,
  });

  final String? keyId;
  final String? initialValue;
  final String? hintText;
  final void Function(String)? onChanged;
  final ColorScheme? colorScheme;

  @override
  Widget build(BuildContext context) {
    var clrScheme = colorScheme ?? Theme.of(context).colorScheme;
    return TextFormField(
      key: keyId != null ? Key(keyId!) : null,
      initialValue: initialValue,
      style: kCodeStyle.copyWith(
        color: clrScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintStyle: kCodeStyle.copyWith(
          color: clrScheme.outline.withOpacity(
            kHintOpacity,
          ),
        ),
        hintText: hintText,
        contentPadding: kP10,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: clrScheme.primary.withOpacity(
              kHintOpacity,
            ),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: clrScheme.surfaceContainerHighest,
          ),
        ),
        isDense: true,
      ),
      onChanged: onChanged,
    );
  }
}
