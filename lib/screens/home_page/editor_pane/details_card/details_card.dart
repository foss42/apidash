import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'request_pane/request_pane.dart';
import 'response_pane.dart';
import 'code_pane.dart';

class EditorPaneRequestDetailsCard extends ConsumerStatefulWidget {
  const EditorPaneRequestDetailsCard({super.key});

  @override
  ConsumerState<EditorPaneRequestDetailsCard> createState() =>
      _EditorPaneRequestDetailsCardState();
}

class _EditorPaneRequestDetailsCardState
    extends ConsumerState<EditorPaneRequestDetailsCard> {
  @override
  Widget build(BuildContext context) {
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    return RequestDetailsCard(
      child: EqualSplitView(
        leftWidget: const EditRequestPane(),
        rightWidget: codePaneVisible ? const CodePane() : const ResponsePane(),
      ),
    );
  }
}
