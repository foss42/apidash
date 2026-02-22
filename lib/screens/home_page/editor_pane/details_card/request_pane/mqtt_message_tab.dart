import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class MqttMessageTab extends ConsumerWidget {
  const MqttMessageTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return kSizedBoxEmpty;

    final contentType =
        ref.watch(mqttPublishContentTypeProvider(selectedId));
    final darkMode = ref.watch(settingsProvider.select(
      (value) => value.isDark,
    ));

    return Column(
      children: [
        SizedBox(
          height: kHeaderHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Content Type:"),
              kHSpacer10,
              ADPopupMenu<ContentType>(
                tooltip: "Select Content Type",
                width: 120,
                value: contentType == ContentType.json ? "JSON" : "Text",
                values: [
                  (ContentType.json, "JSON"),
                  (ContentType.text, "Text"),
                ],
                onChanged: (ContentType? value) {
                  if (value != null) {
                    ref
                        .read(mqttPublishContentTypeProvider(selectedId)
                            .notifier)
                        .state = value;
                  }
                },
                isOutlined: true,
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: kPt5o10,
            child: contentType == ContentType.json
                ? JsonTextFieldEditor(
                    key: Key("$selectedId-mqtt-json-body"),
                    fieldKey: "$selectedId-mqtt-json-body-editor-$darkMode",
                    isDark: darkMode,
                    initialValue:
                        ref.read(mqttPublishPayloadProvider(selectedId)),
                    onChanged: (String value) {
                      ref
                          .read(mqttPublishPayloadProvider(selectedId).notifier)
                          .state = value;
                    },
                    hintText: kHintMqttPayload,
                  )
                : TextFieldEditor(
                    key: Key("$selectedId-mqtt-body"),
                    fieldKey: "$selectedId-mqtt-body-editor",
                    initialValue:
                        ref.read(mqttPublishPayloadProvider(selectedId)),
                    onChanged: (String value) {
                      ref
                          .read(mqttPublishPayloadProvider(selectedId).notifier)
                          .state = value;
                    },
                    hintText: kHintMqttPayload,
                  ),
          ),
        ),
      ],
    );
  }
}
