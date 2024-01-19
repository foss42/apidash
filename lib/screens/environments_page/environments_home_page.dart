import 'package:apidash/screens/environments_page/environments_collections_pane.dart';
import 'package:apidash/screens/environments_page/environments_editor_pane.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentsPage extends ConsumerStatefulWidget {
  const EnvironmentsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnvironmentsPageState();
}

class _EnvironmentsPageState extends ConsumerState<EnvironmentsPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
            child: DashboardSplitView(
          sidebarWidget: EnvironmentsCollectionsPane(),
          mainWidget: EnvironmentsEditorPane(),
        ))
      ],
    );
  }
}
