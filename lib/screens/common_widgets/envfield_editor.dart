import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'env_trigger_field.dart';


class EnvironmentEditorField extends StatelessWidget {
  const EnvironmentEditorField({
    super.key,
    required this.selectedId,
    this.hintText,
    this.initialValue,
    this.onChanged,
  });

  final String selectedId;
  final String? hintText;
  final String? initialValue;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return EnvironmentTriggerField(
      keyId: "body-$selectedId",
      isEditor:true,
      hintText: hintText,
      decoration: InputDecoration(
        hintText: hintText,
        border:OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant, // Use theme color
          ),
          borderRadius: kBorderRadius8,
    ),),
      initialValue: initialValue,
      style: kCodeStyle,
      onChanged: onChanged,
      optionsWidthFactor: 1,
    );
  }
}
