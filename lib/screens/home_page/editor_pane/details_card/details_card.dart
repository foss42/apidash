import 'package:apidash/consts.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/mqtt/mqtt_request_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/mqtt/mqtt_response_pane.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'request_pane/request_pane.dart';
import 'response_pane.dart';
import 'code_pane.dart';

class EditorPaneRequestDetailsCard extends ConsumerWidget {
  const EditorPaneRequestDetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);

    final protocol = ref.watch(selectedRequestModelProvider)?.protocol;
    return RequestDetailsCard(
      child: EqualSplitView(
        leftWidget: protocol == ProtocolType.mqttv3
            ? const MQTTEditRequestPane()
            : const EditRequestPane(),
        rightWidget: codePaneVisible
            ? const CodePane()
            : protocol == ProtocolType.mqttv3
                ? const MQTTResponsePane()
                : const ResponsePane(),
      ),
    );
  }
}
