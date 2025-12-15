import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'env_trigger_field.dart';

class EnvURLField extends StatelessWidget {
  const EnvURLField({
    super.key,
    required this.selectedId,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.onCurlDetected,
  });

  final String selectedId;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final Future<String?> Function(String)? onCurlDetected;

  @override
  Widget build(BuildContext context) {
    return EnvironmentTriggerField(
      keyId: "url-$selectedId",
      initialValue: initialValue,
      focusNode: focusNode,
      style: kCodeStyle,
      decoration: InputDecoration(
        hintText: kHintTextUrlCard,
        hintStyle: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        border: InputBorder.none,
      ),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onCurlDetected: onCurlDetected,
      optionsWidthFactor: 1,
    );
  }
}
