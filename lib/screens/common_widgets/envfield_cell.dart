import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';
import 'env_trigger_field.dart';

class EnvCellField extends StatelessWidget {
  const EnvCellField({
    super.key,
    required this.keyId,
    this.initialValue,
    this.hintText,
    this.onChanged,
    this.colorScheme,
    this.autocompleteNoTrigger,
    this.focusNode,
  });

  final String keyId;
  final String? initialValue;
  final String? hintText;
  final void Function(String)? onChanged;
  final ColorScheme? colorScheme;
  final AutocompleteNoTrigger? autocompleteNoTrigger;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    var clrScheme = colorScheme ?? Theme.of(context).colorScheme;
    return EnvironmentTriggerField(
      keyId: keyId,
      initialValue: initialValue,
      focusNode: focusNode,
      style: kCodeStyle.copyWith(
        color: clrScheme.onSurface,
        fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
      ),
      decoration: getTextFieldInputDecoration(
        clrScheme,
        hintText: hintText,
      ),
      autocompleteNoTrigger: autocompleteNoTrigger,
      onChanged: onChanged,
    );
  }
}
