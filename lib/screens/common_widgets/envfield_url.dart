import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_providers.dart';
import 'env_trigger_field.dart';

class EnvURLField extends ConsumerWidget {
  const EnvURLField({
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
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    double scaleFactor = settings.scaleFactor;

    // Apply scaling to the text style and hint text style
    return EnvironmentTriggerField(
      scaleFactor: scaleFactor,
      keyId: "url-$selectedId",
      initialValue: initialValue,
      style: kCodeStyle.copyWith(
        fontSize: kCodeStyle.fontSize ?? 12 * scaleFactor, // Scale font size
      ),
      decoration: InputDecoration(
        hintText: kHintTextUrlCard,
        hintStyle: kCodeStyle.copyWith(

          fontSize: kCodeStyle.fontSize ?? 14 * scaleFactor,
          color:
              Theme.of(context).colorScheme.outline.withOpacity(kHintOpacity),
        ),
        border: InputBorder.none,
      ),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      optionsWidthFactor:
          1 * scaleFactor, // Scale options width factor if needed
    );
  }
}
