import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'request_pane/request_pane.dart';
import 'response_pane.dart';

class EditorPaneRequestDetailsCard extends ConsumerWidget {
  const EditorPaneRequestDetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codePaneVisible = ref.watch(codePaneVisibleStateProvider);
    return RequestDetailsCard(
      child: EqualSplitView(
        leftWidget: const EditRequestPane(),
        rightWidget: codePaneVisible ? const CodePane() : const ResponsePane(),
      ),
    );
  }
}
