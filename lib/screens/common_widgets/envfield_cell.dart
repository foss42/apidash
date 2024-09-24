import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_providers.dart';
import 'env_trigger_field.dart';

class EnvCellField extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    double scaleFactor = settings.scaleFactor;
    var clrScheme = colorScheme ?? Theme.of(context).colorScheme;

    return EnvironmentTriggerField(
      scaleFactor: scaleFactor,
      keyId: keyId,
      initialValue: initialValue,
      style: kCodeStyle.copyWith(
        fontSize: kCodeStyle.fontSize??8 * scaleFactor,
        color: clrScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintStyle: kCodeStyle.copyWith(
          fontSize: kCodeStyle.fontSize??14 * scaleFactor,
          color: clrScheme.outline.withOpacity(kHintOpacity),
        ),
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric( vertical: 10*scaleFactor),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 2.0 * scaleFactor,
            color: clrScheme.primary.withOpacity(kHintOpacity),
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1.0 * scaleFactor,
            color: clrScheme.surfaceContainerHighest,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
