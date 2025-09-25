import 'package:apidash/dashbot/features/chat/viewmodel/chat_viewmodel.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/screens/common_widgets/agentic_ui_features/ai_ui_designer/generate_ui_dialog.dart';
import 'package:apidash/screens/common_widgets/agentic_ui_features/tool_generation/generate_tool_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../home/view/widgets/home_screen_task_button.dart';
import '../../../../core/providers/dashbot_window_notifier.dart';

class DashbotTaskButtons extends ConsumerWidget {
  const DashbotTaskButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(chatViewmodelProvider.notifier);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Do you want assistance with any of these tasks?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              HomeScreenTaskButton(
                label: '🔎 Explain me this response',
                onPressed: () {
                  vm.sendMessage(
                    text: '',
                    type: ChatMessageType.explainResponse,
                    countAsUser: false,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: '🐞 Help me debug this error',
                onPressed: () {
                  vm.sendMessage(
                    text: '',
                    type: ChatMessageType.debugError,
                    countAsUser: false,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: '📄 Generate documentation',
                onPressed: () {
                  vm.sendMessage(
                    text: '',
                    type: ChatMessageType.generateDoc,
                    countAsUser: false,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: '📝 Generate Tests',
                onPressed: () {
                  vm.sendMessage(
                    text: '',
                    type: ChatMessageType.generateTest,
                    countAsUser: false,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: '🧩 Generate Code',
                onPressed: () {
                  vm.sendMessage(
                    text: '',
                    type: ChatMessageType.generateCode,
                    countAsUser: false,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: '📥 Import cURL',
                onPressed: () {
                  vm.sendMessage(
                    text: '',
                    type: ChatMessageType.importCurl,
                    countAsUser: false,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: '📄 Import OpenAPI',
                onPressed: () {
                  vm.sendMessage(
                    text: '',
                    type: ChatMessageType.importOpenApi,
                    countAsUser: false,
                  );
                },
              ),
              HomeScreenTaskButton(
                label: '🛠️ Generate Tool',
                onPressed: () async {
                  final notifier =
                      ref.read(dashbotWindowNotifierProvider.notifier);
                  notifier.hide();
                  await GenerateToolDialog.show(context, ref);
                  notifier.show();
                },
              ),
              HomeScreenTaskButton(
                label: '📱 Generate UI',
                onPressed: () async {
                  final notifier =
                      ref.read(dashbotWindowNotifierProvider.notifier);
                  notifier.hide();
                  final model = ref.watch(selectedRequestModelProvider
                      .select((value) => value?.httpResponseModel));
                  if (model != null) {
                    String data = '';
                    if (model.sseOutput != null) {
                      data = model.sseOutput!.join('');
                    } else {
                      data = model.formattedBody ?? '<>';
                    }
                    await showCustomDialog(
                      context,
                      GenerateUIDialog(content: data),
                      useRootNavigator: true,
                    );
                  }
                  notifier.show();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
