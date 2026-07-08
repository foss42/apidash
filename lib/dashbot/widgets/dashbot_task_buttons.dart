import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
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
    final vm = ref.read(chatViewmodelProvider.notifier);
    final apiType = ref.watch(
      selectedRequestModelProvider.select((value) => value?.apiType),
    );
    final isWs = apiType == APIType.websocket;
    final isMqtt = apiType == APIType.mqtt;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Do you want assistance with any of these tasks?',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (isWs) ...[
                HomeScreenTaskButton(
                  label: '🔌 Explain this connection',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.explainWsConnection);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '🛠️ Help me fix my connection',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.debugWsConnection);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '📡 What is the server sending?',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.summarizeWsMessages);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '🔍 Find in messages',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.findInWsMessages);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '✉️ Explain my message',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.explainWsMessage);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '❓ Why did my message fail?',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.debugWsMessage);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '❤️ Connection health',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.wsConnectionHealth);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '📄 Generate documentation',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.generateWsDoc);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '📝 Generate Tests',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.generateWsTest);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '🧩 Generate Code',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.generateWsCode);
                    onTaskSelected?.call();
                  },
                ),
              ],
              if (isMqtt) ...[
                HomeScreenTaskButton(
                  label: '🔌 Explain this connection',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.explainMqttConnection);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '🛠️ Help me fix my connection',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.debugMqttConnection);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '📭 Why am I not receiving messages?',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.whyNoMqttMessages);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '📊 What\'s on my topics?',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.summarizeMqttMessages);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '🌳 Topics & wildcards',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.explainMqttTopics);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '💾 Session & offline messages',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.mqttSessionAdvisor);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '🧩 Generate Code',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.generateMqttCode);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '📜 Last Will',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.explainMqttLwt);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '✨ v5 features',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.explainMqttV5);
                    onTaskSelected?.call();
                  },
                ),
                HomeScreenTaskButton(
                  label: '🔍 Find in messages',
                  onPressed: () {
                    vm.sendTaskMessage(ChatMessageType.findInMqttMessages);
                    onTaskSelected?.call();
                  },
                ),
              ],
              if (!isWs && !isMqtt) ...[
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
              ],
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
                  final notifier = ref.read(
                    dashbotWindowNotifierProvider.notifier,
                  );
                  notifier.hide();
                  await GenerateToolDialog.show(context, ref);
                  notifier.show();
                  onTaskSelected?.call();
                },
              ),
              if (!isWs && !isMqtt)
                HomeScreenTaskButton(
                  label: '📱 Generate UI',
                  onPressed: () async {
                    final notifier = ref.read(
                      dashbotWindowNotifierProvider.notifier,
                    );
                    notifier.hide();
                    final model = ref.watch(
                      selectedRequestModelProvider.select(
                        (value) => value?.httpResponseModel,
                      ),
                    );
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
