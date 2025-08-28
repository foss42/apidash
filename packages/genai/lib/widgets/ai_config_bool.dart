import 'package:flutter/material.dart';
import '../models/models.dart';

class AIConfigBool extends StatelessWidget {
  final ModelConfig configuration;
  final Function(ModelConfig) onConfigUpdated;
  final bool readonly;
  const AIConfigBool({
    super.key,
    required this.configuration,
    required this.onConfigUpdated,
    this.readonly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: configuration.value.value as bool,
      onChanged: (x) {
        if (readonly) return;
        configuration.value.value = x;
        onConfigUpdated(configuration);
      },
    );
  }
}
