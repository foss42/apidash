import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'env_trigger_field.dart';

// these changes are made to accomodate MQTT requirements in URL card


class EnvURLField extends StatelessWidget {
  const EnvURLField({
    super.key,
    required this.selectedId,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.decoration,
  });

  final String selectedId;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return EnvironmentTriggerField(
      keyId: "url-$selectedId",
      initialValue: initialValue,
      focusNode: focusNode,
      style: kCodeStyle,
      decoration: decoration ?? InputDecoration(
        hintText: kHintTextUrlCard,
        hintStyle: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        border: InputBorder.none,
      ),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      optionsWidthFactor: 1,
    );
  }
}
