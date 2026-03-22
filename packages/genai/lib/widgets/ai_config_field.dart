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
      onChanged: (x) {
        if (readonly) return;
        if (numeric) {
          if (x.isEmpty) x = '0';
          if (num.tryParse(x) == null) return;
          configuration.value.value = num.parse(x);
        } else {
          configuration.value.value = x;
        }
        onConfigUpdated(configuration);
      },
    );
  }
}
