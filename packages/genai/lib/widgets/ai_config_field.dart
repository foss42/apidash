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
      initialValue: configuration.value.value?.toString() ?? '',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (!numeric || value == null || value.isEmpty) return null;
        final parsed = num.tryParse(value);
        if (parsed == null || !parsed.isFinite) {
          return 'Please enter a valid number';
        }
        return null;
      },
      onChanged: (x) {
        if (readonly) return;
        if (numeric) {
          if (x.isEmpty) x = '0';
          final parsed = num.tryParse(x);
          if (parsed == null || !parsed.isFinite) return;
          configuration.value.value = parsed;
        } else {
          configuration.value.value = x;
        }
        onConfigUpdated(configuration);
      },
    );
  }
}