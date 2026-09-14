import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/models.dart' show ChatMessage;
import 'package:apidash/dashbot/providers/providers.dart';
import 'package:apidash/dashbot/repository/repository.dart';
import 'package:apidash/dashbot/services/agent/prompt_builder.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../providers/helpers.dart';

class _MockRepo extends ChatRemoteRepository {
  @override
  Future<String?> sendChat({required AIRequestModel request}) async =>
      '{"explanation":"ok","actions":[]}';
}

class _PromptCapture extends PromptBuilder {
  String? lastSystemPrompt;

  @override
  String buildSystemPrompt(
    RequestModel? req,
    ChatMessageType type, {
    String? overrideLanguage,
    List<ChatMessage> history = const [],
  }) {
    return lastSystemPrompt = super.buildSystemPrompt(
      req,
      type,
      overrideLanguage: overrideLanguage,
      history: history,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
  });

  test('on the History page DashBot tasks use the selected history entry',
      () async {
    const wsUrl = 'wss://history.example.com/ws';
    final history = HistoryRequestModel(
      historyId: 'his-ws-1',
      metaData: HistoryMetaModel(
        historyId: 'his-ws-1',
        requestId: 'req-1',
        timeStamp: DateTime.now(),
        method: HTTPVerb.get,
        url: wsUrl,
        apiType: APIType.websocket,
        responseStatus: 101,
      ),
      wsRequestModel: const WebSocketRequestModel(url: wsUrl),
    );
    final promptCapture = _PromptCapture();
    final container = createContainer(
      overrides: [
        chatRepositoryProvider.overrideWithValue(_MockRepo()),
        settingsProvider.overrideWith(
          (ref) => ThemeStateNotifier(
            settingsModel: const SettingsModel(
              defaultAIModel: {
                'modelApiProvider': 'openai',
                'model': 'gpt-test',
                'apiKey': 'sk-test',
                'system_prompt': '',
                'user_prompt': '',
                'model_configs': [],
                'stream': false,
              },
            ),
          ),
        ),
        promptBuilderProvider.overrideWith((ref) => promptCapture),
        selectedRequestModelProvider.overrideWith((ref) => null),
        selectedHistoryRequestModelProvider.overrideWith((ref) => history),
        navRailIndexStateProvider.overrideWith((ref) => 2),
      ],
    );

    final vm = container.read(chatViewmodelProvider.notifier);
    await vm.sendTaskMessage(ChatMessageType.generateWsCode);

    expect(container.read(chatViewmodelProvider).chatSessions.keys,
        contains('his-ws-1'));
    expect(promptCapture.lastSystemPrompt, contains(wsUrl));
  });
}
