import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'env_trigger_editor.dart';
import 'env_trigger_field.dart';

class EnvironmentEditorField extends StatelessWidget {
  const EnvironmentEditorField({
    super.key,
    required this.selectedId,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
  });

  final String selectedId;
  final String? hintText;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return EnvironmentTriggerEditor(
      keyId: "body-$selectedId",
      hintText: hintText,
      initialValue: initialValue,
      style: kCodeStyle,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.outline.withOpacity(
            kHintOpacity,
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.none
          )
        ),
      ),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      optionsWidthFactor: 1,
    );
  }
}
