import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import '../mobile/requests_page/requests_page.dart';
import 'editor_pane/editor_pane.dart';
import 'collection_pane.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../mobile/widgets/request_onboarding_panel.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => const Dialog(
            insetPadding: EdgeInsets.all(24),
            child: SizedBox(
              width: 500,
              child: RequestOnboardingPanel(),
            ),
          ),
        );
      });
      return null;
    }, const []);
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
