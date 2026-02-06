import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/screens/common_widgets/agentic_ui_features/ai_ui_designer/generate_ui_dialog.dart';
import 'package:apidash/screens/common_widgets/agentic_ui_features/tool_generation/generate_tool_dialog.dart';
import '../constants.dart';
import '../providers/providers.dart';
import '../routes/routes.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

class DashbotHomePage extends ConsumerStatefulWidget {
  const DashbotHomePage({super.key});

  @override
  ConsumerState<DashbotHomePage> createState() => _DashbotHomePageState();
}

class _DashbotHomePageState extends ConsumerState<DashbotHomePage> {
  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          kVSpacer16(ds.scaleFactor),
          DashbotIcons.getDashbotIcon1(width: 60*ds.scaleFactor),
          kVSpacer16(ds.scaleFactor),
          Text(
            'Hello there,',
            style: TextStyle(fontSize: 18*ds.scaleFactor, fontWeight: FontWeight.w800),
          ),
          Text('How can I help you today?'),
          kVSpacer16(ds.scaleFactor),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (kDebugMode) ...[
                HomeScreenTaskButton(
                  label: "🤖 Chat with Dashbot",
                  onPressed: () {
                    ref.read(dashbotActiveRouteProvider.notifier).goToChat();
                    Navigator.of(context).pushNamed(DashbotRoutes.dashbotChat);
                  },
                ),
              ],
              HomeScreenTaskButton(
                label: "🔎 Explain me this response",
                onPressed: () {
                  ref.read(dashbotActiveRouteProvider.notifier).goToChat();
                  Navigator.of(context).pushNamed(
                    DashbotRoutes.dashbotChat,
                    arguments: ChatMessageType.explainResponse,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: "🐞 Help me debug this error",
                onPressed: () {
                  ref.read(dashbotActiveRouteProvider.notifier).goToChat();
                  Navigator.of(context).pushNamed(
                    DashbotRoutes.dashbotChat,
                    arguments: ChatMessageType.debugError,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: "📄 Generate documentation",
                onPressed: () {
                  ref.read(dashbotActiveRouteProvider.notifier).goToChat();
                  Navigator.of(context).pushNamed(
                    DashbotRoutes.dashbotChat,
                    arguments: ChatMessageType.generateDoc,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: "📝 Generate Tests",
                onPressed: () {
                  ref.read(dashbotActiveRouteProvider.notifier).goToChat();
                  Navigator.of(context).pushNamed(
                    DashbotRoutes.dashbotChat,
                    arguments: ChatMessageType.generateTest,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: "🧩 Generate Code",
                onPressed: () {
                  ref.read(dashbotActiveRouteProvider.notifier).goToChat();
                  Navigator.of(context).pushNamed(
                    DashbotRoutes.dashbotChat,
                    arguments: ChatMessageType.generateCode,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: "📥 Import cURL",
                onPressed: () {
                  ref.read(dashbotActiveRouteProvider.notifier).goToChat();
                  Navigator.of(context).pushNamed(
                    DashbotRoutes.dashbotChat,
                    arguments: ChatMessageType.importCurl,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: "📄 Import OpenAPI",
                onPressed: () {
                  ref.read(dashbotActiveRouteProvider.notifier).goToChat();
                  Navigator.of(context).pushNamed(
                    DashbotRoutes.dashbotChat,
                    arguments: ChatMessageType.importOpenApi,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: "🛠️ Generate Tool",
                onPressed: () async {
                  final notifier =
                      ref.read(dashbotWindowNotifierProvider.notifier);
                  notifier.hide();
                  await GenerateToolDialog.show(context, ref);
                  notifier.show();
                },
              ),
              HomeScreenTaskButton(
                label: "📱 Generate UI",
                onPressed: () async {
                  final notifier =
                      ref.read(dashbotWindowNotifierProvider.notifier);
                  notifier.hide();
                  final model = ref.watch(selectedRequestModelProvider
                      .select((value) => value?.httpResponseModel));
                  if (model == null) return;

                  String data = "";
                  if (model.sseOutput != null) {
                    data = model.sseOutput!.join('');
                  } else {
                    data = model.formattedBody ?? "<>";
                  }

                  await showCustomDialog(
                    context,
                    GenerateUIDialog(content: data),
                    useRootNavigator: true,
                  );
                  notifier.show();
                },
              ),
            ],
          ),
          kVSpacer20(ds.scaleFactor),
        ],
      ),
    );
  }
}
