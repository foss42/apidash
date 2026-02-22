import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import '../../../../common_widgets/common_widgets.dart';

class MqttAuthTab extends ConsumerWidget {
  const MqttAuthTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return kSizedBoxEmpty;

    final mqttModel = ref.watch(selectedRequestModelProvider
        .select((value) => value?.mqttRequestModel));
    final hasAuth = mqttModel?.hasAuth ?? false;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Auth Type",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ADPopupMenu<String>(
              value: hasAuth ? "Basic Auth" : "No Auth",
              values: const [
                ("none", "No Auth"),
                ("basic", "Basic Auth"),
              ],
              tooltip: "Select Auth Type",
              isOutlined: true,
              onChanged: (String? value) {
                if (value == "none") {
                  ref.read(collectionStateNotifierProvider.notifier).update(
                        mqttRequestModel: mqttModel?.copyWith(
                          username: null,
                          password: null,
                        ),
                      );
                }
                // For "basic", just keep the fields visible — user fills them
              },
            ),
            const SizedBox(height: 32),
            if (hasAuth || true) ...[
              // Always show fields so user can enter credentials
              const Text(
                kLabelUsername,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              EnvironmentTriggerField(
                keyId: "mqtt-auth-user-$selectedId",
                initialValue: mqttModel?.username ?? "",
                style: kCodeStyle,
                decoration: InputDecoration(
                  hintText: "Enter username",
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
                            mqttModel?.copyWith(username: value),
                      );
                },
                optionsWidthFactor: 1,
              ),
              const SizedBox(height: 16),
              const Text(
                kLabelPassword,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              EnvironmentTriggerField(
                keyId: "mqtt-auth-pass-$selectedId",
                initialValue: mqttModel?.password ?? "",
                style: kCodeStyle,
                decoration: InputDecoration(
                  hintText: "Enter password",
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
                            mqttModel?.copyWith(password: value),
                      );
                },
                optionsWidthFactor: 1,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
