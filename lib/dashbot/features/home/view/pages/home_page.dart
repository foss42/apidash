import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/screens/common_widgets/agentic_ui_features/ai_ui_designer/generate_ui_dialog.dart';
import 'package:apidash/screens/common_widgets/agentic_ui_features/tool_generation/generate_tool_dialog.dart';

import '../../../../core/utils/dashbot_icons.dart';

import '../../../../core/routes/dashbot_routes.dart';
import 'package:apidash_design_system/tokens/measurements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../chat/models/chat_models.dart';
import '../widgets/home_screen_task_button.dart';

class DashbotHomePage extends ConsumerStatefulWidget {
  const DashbotHomePage({super.key});

  @override
  ConsumerState<DashbotHomePage> createState() => _DashbotHomePageState();
}

class _DashbotHomePageState extends ConsumerState<DashbotHomePage> {
  @override
  Widget build(BuildContext context) {
    final currentRequest = ref.watch(selectedRequestModelProvider);

    ref.listen(
      selectedRequestModelProvider,
      (current, next) {
        if (current?.id != next?.id) {
          Navigator.pop(context);
        }
      },
    );
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          kVSpacer16,
          DashbotIcons.getDashbotIcon1(width: 60),
          kVSpacer16,
          Text(
            'Hello there,',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          Text('How can I help you today?'),
          kVSpacer16,
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              HomeScreenTaskButton(
                label: "🤖 Chat with Dashbot",
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    DashbotRoutes.dashbotChat,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: "🔎 Explain me this response",
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    DashbotRoutes.dashbotChat,
                    arguments: ChatMessageType.explainResponse,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: "🐞 Help me debug this error",
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    DashbotRoutes.dashbotChat,
                    arguments: ChatMessageType.debugError,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: "📄 Generate documentation",
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    DashbotRoutes.dashbotChat,
                    arguments: ChatMessageType.general,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: "📝 Generate Tests",
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    DashbotRoutes.dashbotChat,
                    arguments: ChatMessageType.generateTest,
                  );
                },
              ),
              if (currentRequest?.httpResponseModel?.statusCode != null &&
                  currentRequest?.httpResponseModel?.statusCode == 200) ...[
                Expanded(
                  child: GenerateToolButton(),
                ),
                Expanded(
                  child: AIGenerateUIButton(),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
