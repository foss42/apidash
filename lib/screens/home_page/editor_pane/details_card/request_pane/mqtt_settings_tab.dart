import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';

class MqttSettingsTab extends ConsumerWidget {
  const MqttSettingsTab({super.key});

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
              kHintMqttPort,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 120,
              child: TextFormField(
                key: Key("mqtt-port-$selectedId"),
                initialValue: (mqttModel?.port ?? 1883).toString(),
                style: kCodeStyle,
                decoration: const InputDecoration(
                  hintText: "1883",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  final port = int.tryParse(value) ?? 1883;
                  ref.read(collectionStateNotifierProvider.notifier).update(
                        mqttRequestModel:
                            mqttModel?.copyWith(port: port),
                      );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              kLabelKeepAlive,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 120,
              child: TextFormField(
                key: Key("mqtt-keepalive-$selectedId"),
                initialValue: (mqttModel?.keepAlive ?? 60).toString(),
                style: kCodeStyle,
                decoration: const InputDecoration(
                  hintText: "60",
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  final keepAlive = int.tryParse(value) ?? 60;
                  ref.read(collectionStateNotifierProvider.notifier).update(
                        mqttRequestModel:
                            mqttModel?.copyWith(keepAlive: keepAlive),
                      );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  kLabelCleanStart,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                kHSpacer10,
                Switch(
                  value: mqttModel?.cleanSession ?? true,
                  onChanged: (value) {
                    ref.read(collectionStateNotifierProvider.notifier).update(
                          mqttRequestModel:
                              mqttModel?.copyWith(cleanSession: value),
                        );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  kLabelMqttVersion,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                kHSpacer10,
                Text(
                  mqttModel?.mqttVersion.label ?? MqttVersion.v311.label,
                  style: kCodeStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
