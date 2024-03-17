import 'package:apidash/consts.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/mqtt/mqtt_connection_config.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/mqtt/mqtt_message_body.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/mqtt/mqtt_request_properties.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/mqtt/mqtt_topics_pane.dart';
import 'package:apidash/widgets/mqtt/mqtt_request_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';

class MQTTEditRequestPane extends ConsumerWidget {
  const MQTTEditRequestPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    final tabIndex = ref.watch(
        selectedRequestModelProvider.select((value) => value?.requestTabIndex));

    final headerLength = ref.watch(selectedRequestModelProvider
        .select((value) => value?.headersMap.length));
    final paramLength = ref.watch(selectedRequestModelProvider
        .select((value) => value?.paramsMap.length));
    final bodyLength = ref.watch(selectedRequestModelProvider
        .select((value) => value?.requestBody?.length));

    return Column(
      children: [
        Expanded(
          child: MQTTRequestPane(
            selectedId: selectedId,
            tabIndex: tabIndex,
            onTapTabBar: (index) {
              ref
                  .read(collectionStateNotifierProvider.notifier)
                  .update(selectedId!, requestTabIndex: index);
            },
            showIndicators: [
              bodyLength != null && bodyLength > 0,
              paramLength != null && paramLength > 0,
              headerLength != null && headerLength > 0,
            ],
            tabLabels: const [
              'Message',
              'Connection Configuration',
              'Properties'
            ],
            children: const [
              EditMessageBody(),
              MQTTConnectionConfigParams(),
              MQTTEditRequestProperties(),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: kBorderRadius12,
            ),
            margin: kP10,
            child: const MQTTTopicsPane(),
          ),
        )
      ],
    );
  }
}
