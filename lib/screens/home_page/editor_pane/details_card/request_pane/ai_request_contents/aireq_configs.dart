import 'package:apidash/models/llm_models/google/gemini_20_flash.dart';
import 'package:apidash/models/llm_models/llm_config.dart';
import 'package:apidash/widgets/editor.dart';
import 'package:apidash_design_system/widgets/textfield_outlined.dart';
import 'package:flutter/material.dart';

class AIRequestConfigSection extends StatelessWidget {
  const AIRequestConfigSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ...Gemini20FlashModel()
              .configurations
              .map(
                (el) => ListTile(
                  title: Text(el.configName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        el.configDescription,
                        style: TextStyle(color: Colors.white30),
                      ),
                      SizedBox(height: 5),
                      if (el.configType ==
                          LLMModelConfigurationType.boolean) ...[
                        Switch(
                          value: el.configValue.value as bool,
                          onChanged: (x) {},
                        )
                      ] else if (el.configType ==
                          LLMModelConfigurationType.numeric) ...[
                        ADOutlinedTextField(
                          initialValue: el.configValue.value.toString(),
                        )
                      ] else if (el.configType ==
                          LLMModelConfigurationType.slider) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                min: (el.configValue.value as (
                                  double,
                                  double,
                                  double
                                ))
                                    .$1,
                                value: (el.configValue.value as (
                                  double,
                                  double,
                                  double
                                ))
                                    .$2,
                                max: (el.configValue.value as (
                                  double,
                                  double,
                                  double
                                ))
                                    .$3,
                                onChanged: (x) {},
                              ),
                            ),
                            Text((el.configValue.value as (
                              double,
                              double,
                              double
                            ))
                                .$2
                                .toString()),
                          ],
                        )
                      ],
                      SizedBox(height: 10),
                      Divider(color: Colors.white10),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
