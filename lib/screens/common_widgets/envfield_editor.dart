import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'env_trigger_editor.dart';
import 'env_trigger_field.dart';

class EnvEditorField extends StatelessWidget {
  const EnvEditorField({
    super.key,
    required this.selectedId,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
  });

  final String selectedId;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return EnvTriggerEditor(
      keyId: "url-$selectedId",
      initialValue: initialValue,
      style: kCodeStyle,
      decoration: InputDecoration(
        hintText: kHintTextUrlCard,
        hintStyle: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.outline.withOpacity(
            kHintOpacity,
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid
          )
        ),
      ),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      optionsWidthFactor: 1,
    );
  }
}
