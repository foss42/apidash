import 'package:flutter/material.dart';
import '../models/models.dart';

class AIConfigField extends StatelessWidget {
  final bool numeric;
  final ModelConfig configuration;
  final Function(ModelConfig) onConfigUpdated;
  final bool readonly;
  const AIConfigField({
    super.key,
    this.numeric = false,
    required this.configuration,
    required this.onConfigUpdated,
    this.readonly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: configuration.value.value.toString(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: numeric
          ? (x) {
              if (x == null || x.isEmpty) return null;
              final parsed = num.tryParse(x);
              if (parsed == null) {
                return 'Invalid value: must be a number';
              }
              if (parsed is double &&
                  (parsed.isInfinite || parsed.isNaN)) {
                return 'Invalid token value: Infinity and NaN are not allowed.';
              }
              return null;
            }
          : null,
      onChanged: (x) {
        if (readonly) return;
        if (numeric) {
          if (x.isEmpty) x = '0';
          final parsed = num.tryParse(x);
          configuration.value.value = parsed ?? double.nan;
        } else {
          configuration.value.value = x;
        }
        onConfigUpdated(configuration);
      },
    );
  }
}
