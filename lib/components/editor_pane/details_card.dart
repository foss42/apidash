import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'request_pane.dart';
import 'response_pane.dart';
import '../styles.dart';

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
      shape: cardShape,
      child: MultiSplitViewTheme(
        data: MultiSplitViewThemeData(
          dividerThickness: 3,
          dividerPainter: DividerPainters.background(
            color: colorGrey200,
            highlightedColor: colorGrey400,
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
