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
  });

  final String selectedId;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return EnvironmentTriggerField(
      keyId: "url-$selectedId",
      initialValue: initialValue,
      focusNode: focusNode,
      style: kCodeStyle.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      decoration: InputDecoration(
        hintText: kHintTextUrlCard,
        hintStyle: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.outlineVariant,
          fontWeight: FontWeight.normal,
        ),
        border: InputBorder.none,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.link,
            size: 18,
            color: isDark ? Colors.cyan.shade300 : Colors.cyan.shade700,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
      ),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      optionsWidthFactor: 1,
    );
  }
}
