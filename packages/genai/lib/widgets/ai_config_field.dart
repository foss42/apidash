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
      decoration: const InputDecoration(
        errorMaxLines: 2,
      ),
      validator: numeric
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Value cannot be empty';
              }
              final parsed = num.tryParse(value);
              if (parsed == null) {
                return 'Please enter a valid number';
              }
              if (parsed is double && (parsed.isNaN || parsed.isInfinite)) {
                return 'Invalid value: Infinity and NaN are not allowed';
              }
              return null;
            }
          : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (x) {
        if (readonly) return;
        if (numeric) {
          if (x.isEmpty) x = '0';
          final parsed = num.tryParse(x);
          if (parsed == null) return;
          // Reject Infinity and NaN
          if (parsed is double && (parsed.isNaN || parsed.isInfinite)) {
            return;
          }
          configuration.value.value = parsed;
        } else {
          configuration.value.value = x;
        }
        onConfigUpdated(configuration);
      },
    );
  }
}
