import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/extensions/extensions.dart';
import '../mobile/requests_page/requests_page.dart';
import 'editor_pane/editor_pane.dart';
import 'collection_pane.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
