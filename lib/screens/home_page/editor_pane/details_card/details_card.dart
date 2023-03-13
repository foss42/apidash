import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:apidash/consts.dart';
import 'request_pane/request_pane.dart';
import 'response_pane/response_pane.dart';

class EditorPaneRequestDetailsCard extends StatefulWidget {
  const EditorPaneRequestDetailsCard({super.key});

  @override
  State<EditorPaneRequestDetailsCard> createState() =>
      _EditorPaneRequestDetailsCardState();
}

class _EditorPaneRequestDetailsCardState
    extends State<EditorPaneRequestDetailsCard> {
  final MultiSplitViewController _controller = MultiSplitViewController(
    areas: [
      Area(minimalSize: 300),
      Area(minimalSize: 300),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        borderRadius: kBorderRadius12,
      ),
      elevation: 0,
      child: MultiSplitViewTheme(
        data: MultiSplitViewThemeData(
          dividerThickness: 3,
          dividerPainter: DividerPainters.background(
            color: Theme.of(context).colorScheme.surfaceVariant,
            highlightedColor: Theme.of(context).colorScheme.outline.withOpacity(
                  kHintOpacity,
                ),
            animationEnabled: false,
          ),
        ),
        child: MultiSplitView(
          controller: _controller,
          children: const [
            EditRequestPane(),
            ResponsePane(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
