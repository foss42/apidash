import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/websocket_request_pane.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'code_pane.dart';
import 'request_pane/http_request_pane.dart';
import 'response_pane.dart';

class EditorPaneRequestDetailsCard extends ConsumerWidget {
  const EditorPaneRequestDetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    final protocol = ref
        .watch(selectedRequestModelProvider.select((value) => value?.protocol));
    return protocol == Protocol.http
        ? RequestDetailsCard(
            child: EqualSplitView(
              leftWidget: const EditHTTPRequestPane(),
              rightWidget:
                  codePaneVisible ? const CodePane() : const ResponsePane(),
            ),
          )
        : RequestDetailsCard(
            child: EqualSplitView(
              leftWidget: const EditWebSocketRequestPane(),
              rightWidget:
                  codePaneVisible ? const CodePane() : const ResponsePane(),
            ),
          );
  }
}
