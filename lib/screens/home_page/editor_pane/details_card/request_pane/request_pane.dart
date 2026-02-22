import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/dashbot/dashbot.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import '../response_pane.dart';
import 'ai_request/request_pane_ai.dart';
import 'request_pane_graphql.dart';
import 'request_pane_mqtt.dart';
import 'request_pane_rest.dart';
import 'request_pane_ws.dart';

class EditRequestPane extends ConsumerWidget {
  const EditRequestPane({
    super.key,
    this.showViewCodeButton = true,
  });

  final bool showViewCodeButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
    final isPopped =
        ref.watch(dashbotWindowNotifierProvider.select((s) => s.isPopped));

    // When Dashbot window is not popped, show compact segmented layout like History page
    if (!isPopped && !context.isMediumWindow) {
      return DefaultTabController(
        length: 3,
        child: Builder(
          builder: (context) {
            final controller = DefaultTabController.of(context);
            return Column(
              children: [
                kVSpacer10,
                SegmentedTabbar(
                  controller: controller,
                  tabs: const [
                    Tab(text: kLabelRequest),
                    Tab(text: kLabelResponse),
                    Tab(text: kLabelCode),
                  ],
                ),
                kVSpacer10,
                Expanded(
                  child: TabBarView(
                    controller: controller,
                    children: [
                      switch (apiType) {
                        APIType.rest => EditRestRequestPane(
                            showViewCodeButton: false,
                          ),
                        APIType.graphql => EditGraphQLRequestPane(
                            showViewCodeButton: false,
                          ),
                        APIType.ai => EditAIRequestPane(
                            showViewCodeButton: false,
                          ),
                        _ => kSizedBoxEmpty,
                      },
                      ResponsePane(),
                      CodePane(),
                    ],
                  ),
                ),
                kVSpacer8,
              ],
            );
          },
        ),
      );
    }

    if (isPopped == false && apiType == APIType.mqtt) {
      return const EditMqttRequestPane();
    }

    return switch (apiType) {
      APIType.rest => const EditRestRequestPane(),
      APIType.graphql => const EditGraphQLRequestPane(),
      APIType.ai => const EditAIRequestPane(),
      APIType.mqtt => const EditMqttRequestPane(),
      APIType.websocket => const EditWSRequestPane(),
      APIType.rest => EditRestRequestPane(
          showViewCodeButton: showViewCodeButton,
        ),
      APIType.graphql => EditGraphQLRequestPane(
          showViewCodeButton: showViewCodeButton,
        ),
      APIType.ai => EditAIRequestPane(
          showViewCodeButton: showViewCodeButton,
        ),
      _ => kSizedBoxEmpty,
    };
  }
}
