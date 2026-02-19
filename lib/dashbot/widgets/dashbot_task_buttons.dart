import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/screens/common_widgets/agentic_ui_features/ai_ui_designer/generate_ui_dialog.dart';
import 'package:apidash/screens/common_widgets/agentic_ui_features/tool_generation/generate_tool_dialog.dart';
import '../constants.dart';
import '../providers/providers.dart';
import 'home_screen_task_button.dart';

class DashbotTaskButtons extends ConsumerWidget {
  final VoidCallback? onTaskSelected;

  const DashbotTaskButtons({super.key, this.onTaskSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ds = DesignSystemProvider.of(context);
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
          SizedBox(height: 12*ds.scaleFactor),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              HomeScreenTaskButton(
                label: '🔎 Explain me this response',
                onPressed: () {
                  vm.sendTaskMessage(ChatMessageType.explainResponse);
                  onTaskSelected?.call();
                },
              ),
              HomeScreenTaskButton(
                label: '🐞 Help me debug this error',
                onPressed: () {
                  vm.sendTaskMessage(ChatMessageType.debugError);
                  onTaskSelected?.call();
                },
              ),
              HomeScreenTaskButton(
                label: '📄 Generate documentation',
                onPressed: () {
                  vm.sendTaskMessage(ChatMessageType.generateDoc);
                  onTaskSelected?.call();
                },
              ),
              HomeScreenTaskButton(
                label: '📝 Generate Tests',
                onPressed: () {
                  vm.sendTaskMessage(ChatMessageType.generateTest);
                  onTaskSelected?.call();
                },
              ),
              HomeScreenTaskButton(
                label: '🧩 Generate Code',
                onPressed: () {
                  vm.sendTaskMessage(ChatMessageType.generateCode);
                  onTaskSelected?.call();
                },
              ),
              HomeScreenTaskButton(
                label: '📥 Import cURL',
                onPressed: () {
                  vm.sendTaskMessage(ChatMessageType.importCurl);
                  onTaskSelected?.call();
                },
              ),
              HomeScreenTaskButton(
                label: '📄 Import OpenAPI',
                onPressed: () {
                  vm.sendTaskMessage(ChatMessageType.importOpenApi);
                  onTaskSelected?.call();
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
                  onTaskSelected?.call();
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
                  onTaskSelected?.call();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
