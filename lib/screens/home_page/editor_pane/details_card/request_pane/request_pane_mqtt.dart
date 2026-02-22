import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'mqtt_message_tab.dart';
import 'mqtt_topics_tab.dart';
import 'mqtt_auth_tab.dart';
import 'mqtt_last_will_tab.dart';
import 'mqtt_settings_tab.dart';
import '../../../../common_widgets/common_widgets.dart';

class EditMqttRequestPane extends ConsumerWidget {
  const EditMqttRequestPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    final tabIndex = ref.watch(
        selectedRequestModelProvider.select((value) => value?.requestTabIndex));
    final mqttModel = ref.watch(selectedRequestModelProvider
        .select((value) => value?.mqttRequestModel));

    final topicLength = mqttModel?.topics.length ?? 0;
    final hasAuth = mqttModel?.hasAuth ?? false;
    final hasLastWill = mqttModel?.hasLastWill ?? false;

    var currentTabIndex = tabIndex ?? 0;
    if (currentTabIndex >= 5) {
      currentTabIndex = 0;
    }

    return Column(
      children: [
        Expanded(
          child: RequestPane(
            selectedId: selectedId,
            codePaneVisible: codePaneVisible,
            tabIndex: currentTabIndex,
            onPressedCodeButton: () {
              ref.read(codePaneVisibleStateProvider.notifier).state =
                  !codePaneVisible;
            },
            onTapTabBar: (index) {
              ref
                  .read(collectionStateNotifierProvider.notifier)
                  .update(requestTabIndex: index);
            },
            showViewCodeButton: false,
            tabLabels: const [
              kLabelMessage,
              kLabelTopics,
              kLabelAuth,
              kLabelLastWill,
              kLabelMqttSettings,
            ],
            showIndicators: [
              false,
              topicLength > 0,
              hasAuth,
              hasLastWill,
              false,
            ],
            children: const [
              MqttMessageTab(),
              MqttTopicsTab(),
              MqttAuthTab(),
              MqttLastWillTab(),
              MqttSettingsTab(),
            ],
          ),
        ),
        MqttBottomBar(selectedId: selectedId),
      ],
    );
  }
}

class MqttBottomBar extends ConsumerWidget {
  const MqttBottomBar({super.key, this.selectedId});
  final String? selectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selectedId == null) return kSizedBoxEmpty;

    final retain = ref.watch(mqttPublishRetainProvider(selectedId!));
    final qos = ref.watch(mqttPublishQosProvider(selectedId!));
    final connectionInfo = ref.watch(mqttConnectionProvider(selectedId!));
    final isConnected =
        connectionInfo.state == MqttConnectionState.connected;
    final publishTopic = ref.watch(mqttPublishTopicProvider(selectedId!));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
      ),
      child: Row(
        children: [
          // Retain checkbox
          SizedBox(
            height: 24,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: retain,
                  onChanged: (value) {
                    ref
                        .read(mqttPublishRetainProvider(selectedId!).notifier)
                        .state = value ?? false;
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                const Text(kLabelRetain, style: kTextStyleButton),
              ],
            ),
          ),
          kHSpacer10,
          // QoS badge
          ADPopupMenu<MqttQos>(
            tooltip: kLabelQos,
            width: 60,
            value: qos.label,
            values: MqttQos.values.map((e) => (e, e.label)),
            onChanged: (MqttQos? value) {
              if (value != null) {
                ref
                    .read(mqttPublishQosProvider(selectedId!).notifier)
                    .state = value;
              }
            },
            isOutlined: true,
          ),
          kHSpacer10,
          // Topic field
          Expanded(
            child: SizedBox(
              height: 32,
              child: EnvironmentTriggerField(
                keyId: "mqtt-pub-topic-$selectedId",
                initialValue: publishTopic,
                style: kCodeStyle.copyWith(fontSize: 12),
                decoration: InputDecoration(
                  hintText: kHintMqttTopic,
                  hintStyle: kCodeStyle.copyWith(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  border: OutlineInputBorder(
                    borderRadius: kBorderRadius8,
                    borderSide: BorderSide(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
                onChanged: (value) {
                  ref
                      .read(mqttPublishTopicProvider(selectedId!).notifier)
                      .state = value;
                },
                optionsWidthFactor: 1,
              ),
            ),
          ),
          kHSpacer10,
          // Send button
          SizedBox(
            height: 32,
            child: ADFilledButton(
              onPressed: isConnected
                  ? () {
                      final topic = ref.read(
                          mqttPublishTopicProvider(selectedId!));
                      final payload = ref.read(
                          mqttPublishPayloadProvider(selectedId!));
                      final pubQos = ref.read(
                          mqttPublishQosProvider(selectedId!));
                      final pubRetain = ref.read(
                          mqttPublishRetainProvider(selectedId!));
                      if (topic.trim().isNotEmpty) {
                        ref
                            .read(
                                collectionStateNotifierProvider.notifier)
                            .publishMqtt(
                                topic, payload, pubQos, pubRetain);
                      }
                    }
                  : null,
              items: const [
                Icon(size: 16, Icons.send),
                kHSpacer4,
                Text(kLabelSend, style: kTextStyleButton),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
