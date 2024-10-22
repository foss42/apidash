import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'env_trigger_field.dart';

class EnvCellField extends StatelessWidget {
  const EnvCellField({
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
    var clrScheme = colorScheme ?? Theme.of(context).colorScheme;
    return EnvironmentTriggerField(
      keyId: keyId,
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
      onChanged: onChanged,
    );
  }
}
