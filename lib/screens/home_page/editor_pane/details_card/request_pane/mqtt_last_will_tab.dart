import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import '../../../../common_widgets/common_widgets.dart';

class MqttLastWillTab extends ConsumerWidget {
  const MqttLastWillTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return kSizedBoxEmpty;

    final mqttModel = ref.watch(selectedRequestModelProvider
        .select((value) => value?.mqttRequestModel));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              kLabelLastWillTopic,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            EnvironmentTriggerField(
              keyId: "mqtt-lwt-topic-$selectedId",
              initialValue: mqttModel?.lastWillTopic ?? "",
              style: kCodeStyle,
              decoration: InputDecoration(
                hintText: "e.g. /client/disconnected",
                hintStyle: kCodeStyle.copyWith(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) {
                ref.read(collectionStateNotifierProvider.notifier).update(
                      mqttRequestModel:
                          mqttModel?.copyWith(lastWillTopic: value),
                    );
              },
              optionsWidthFactor: 1,
            ),
            const SizedBox(height: 16),
            const Text(
              kLabelLastWillMessage,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            EnvironmentTriggerField(
              keyId: "mqtt-lwt-msg-$selectedId",
              initialValue: mqttModel?.lastWillMessage ?? "",
              style: kCodeStyle,
              decoration: InputDecoration(
                hintText: "Enter last will message",
                hintStyle: kCodeStyle.copyWith(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) {
                ref.read(collectionStateNotifierProvider.notifier).update(
                      mqttRequestModel:
                          mqttModel?.copyWith(lastWillMessage: value),
                    );
              },
              optionsWidthFactor: 1,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      kLabelLastWillQos,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ADPopupMenu<MqttQos>(
                      tooltip: kLabelLastWillQos,
                      width: 80,
                      value: mqttModel?.lastWillQos.label ??
                          MqttQos.atMostOnce.label,
                      values: MqttQos.values.map((e) => (e, e.label)),
                      onChanged: (MqttQos? value) {
                        if (value != null) {
                          ref
                              .read(
                                  collectionStateNotifierProvider.notifier)
                              .update(
                                mqttRequestModel:
                                    mqttModel?.copyWith(lastWillQos: value),
                              );
                        }
                      },
                      isOutlined: true,
                    ),
                  ],
                ),
                kHSpacer20,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      kLabelLastWillRetain,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Switch(
                      value: mqttModel?.lastWillRetain ?? false,
                      onChanged: (value) {
                        ref
                            .read(
                                collectionStateNotifierProvider.notifier)
                            .update(
                              mqttRequestModel:
                                  mqttModel?.copyWith(lastWillRetain: value),
                            );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
