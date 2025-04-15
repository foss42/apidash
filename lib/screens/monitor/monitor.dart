import 'package:apidash/screens/home_page/collection_pane.dart';
import 'package:apidash/screens/home_page/editor_pane/editor_pane.dart';
import 'package:apidash/screens/mobile/requests_page/requests_page.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';

class MonitorPage extends StatelessWidget {
  const MonitorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return context.isMediumWindow
        ? const RequestResponsePage()
        : const Column(
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