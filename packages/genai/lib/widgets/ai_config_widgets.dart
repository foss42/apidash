import 'package:apidash_design_system/widgets/textfield_outlined.dart';
import 'package:flutter/material.dart';
import 'package:genai/llm_config.dart';

class SliderAIConfig extends StatelessWidget {
  final LLMModelConfiguration configuration;
  final Function(LLMModelConfiguration) onSliderUpdated;
  const SliderAIConfig({
    super.key,
    required this.configuration,
    required this.onSliderUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            min: (configuration.configValue.value as (double, double, double))
                .$1,
            value: (configuration.configValue.value as (double, double, double))
                .$2,
            max: (configuration.configValue.value as (double, double, double))
                .$3,
            onChanged: (x) {
              final z =
                  configuration.configValue.value as (double, double, double);
              configuration.configValue.value = (z.$1, x, z.$3);
              onSliderUpdated(configuration);
            },
          ),
        ),
        Text((configuration.configValue.value as (double, double, double))
            .$2
            .toStringAsFixed(2)),
      ],
    );
  }
}

class WritableAIConfig extends StatelessWidget {
  final bool numeric;
  final LLMModelConfiguration configuration;
  final Function(LLMModelConfiguration) onConfigUpdated;
  const WritableAIConfig({
    super.key,
    this.numeric = false,
    required this.configuration,
    required this.onConfigUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return ADOutlinedTextField(
      initialValue: configuration.configValue.value.toString(),
      onChanged: (x) {
        if (numeric) {
          if (x.isEmpty) x = '0';
          if (num.tryParse(x) == null) return;
          configuration.configValue.value = num.parse(x);
        } else {
          configuration.configValue.value = x;
        }
        onConfigUpdated(configuration);
      },
    );
  }
}

class BooleanAIConfig extends StatelessWidget {
  final LLMModelConfiguration configuration;
  final Function(LLMModelConfiguration) onConfigUpdated;
  const BooleanAIConfig({
    super.key,
    required this.configuration,
    required this.onConfigUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: configuration.configValue.value as bool,
      onChanged: (x) {
        configuration.configValue.value = x;
        onConfigUpdated(configuration);
      },
    );
  }
}
