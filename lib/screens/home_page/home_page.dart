import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import 'editor_pane/editor_pane.dart';
import 'collection_pane.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          child: DashboardSplitView(
            sidebarWidget: CollectionPane(),
            mainWidget: RequestEditorPane(),
          ),
        ),
      ],
    );
  }
}
