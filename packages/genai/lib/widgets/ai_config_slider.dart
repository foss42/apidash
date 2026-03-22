import 'package:flutter/material.dart';
import '../models/models.dart';

class AIConfigSlider extends StatelessWidget {
  final ModelConfig configuration;
  final Function(ModelConfig) onSliderUpdated;
  final bool readonly;
  const AIConfigSlider({
    super.key,
    required this.configuration,
    required this.onSliderUpdated,
    this.readonly = false,
  });

  @override
  Widget build(BuildContext context) {
    final val = configuration.value.value as (double, double, double);
    return Row(
      children: [
        Expanded(
          child: Slider(
            min: val.$1,
            value: val.$2,
            max: val.$3,
            onChanged: (x) {
              if (readonly) return;
              configuration.value.value = (val.$1, x, val.$3);
              onSliderUpdated(configuration);
            },
          ),
        ),
        Text(val.$2.toStringAsFixed(2)),
      ],
    );
  }
}
