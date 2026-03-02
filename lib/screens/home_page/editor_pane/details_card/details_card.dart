import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash/dashbot/dashbot.dart';
import 'request_pane/request_pane.dart';
import 'response_pane.dart';
import 'response_pane_websocket.dart';
import 'package:apidash_core/apidash_core.dart';

class EditorPaneRequestDetailsCard extends ConsumerWidget {
  const EditorPaneRequestDetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    final isDashbotPopped = ref.watch(dashbotWindowNotifierProvider).isPopped;
    return RequestDetailsCard(
      child: EqualSplitView(
        leftWidget: const EditRequestPane(),
        rightWidget: !isDashbotPopped
            ? DashbotTab()
            : codePaneVisible
                ? const CodePane()
                : switch (ref.watch(selectedRequestModelProvider
                    .select((value) => value?.apiType))) {
                    APIType.websocket => const WebSocketResponsePane(),
                    _ => const ResponsePane(),
                  },
      ),
    );
  }
}
