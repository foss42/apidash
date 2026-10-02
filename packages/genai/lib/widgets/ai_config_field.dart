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
          final parsed = num.tryParse(x);
          // Reject non-finite values (e.g. "1e309" -> Infinity, "NaN"):
          // they later crash JSON encoding of the request body. See #1264.
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
