import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import '../mobile/requests_page/request_response_page.dart';
import 'editor_pane/editor_pane.dart';
import 'collection_pane.dart';
import 'home_bottom_terminal_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return context.isMediumWindow
        ? const RequestResponsePage()
        : Column(
            children: [
              const Expanded(
                child: DashboardSplitView(
                  sidebarWidget: CollectionPane(),
                  mainWidget: RequestEditorPane(),
                ),
              ),
              if (kIsDesktop) const HomeBottomTerminalBar(),
            ],
          );
  }
}
