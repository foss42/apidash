import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/chat_action.dart';
import 'package:apidash/dashbot/models/chat_attachment.dart';
import 'package:apidash/dashbot/providers/chat_viewmodel.dart';
import 'package:apidash/dashbot/providers/dashbot_window_notifier.dart';

class TestChatViewmodel extends ChatViewmodel {
  TestChatViewmodel(super.ref);

  final List<ChatAction> applyAutoFixCalls = [];
  final List<({String text, ChatMessageType type, bool countAsUser})>
      sendMessageCalls = [];
  final List<ChatAttachment> openApiAttachmentCalls = [];

  bool throwOnApplyAutoFix = false;

  @override
  Future<void> applyAutoFix(ChatAction action) async {
    applyAutoFixCalls.add(action);
    if (throwOnApplyAutoFix) {
      throw Exception('applyAutoFix error');
    }
  }

  @override
  Future<void> sendMessage({
    required String text,
    ChatMessageType type = ChatMessageType.general,
    bool countAsUser = true,
  }) async {
    sendMessageCalls.add((text: text, type: type, countAsUser: countAsUser));
  }

  @override
  Future<void> handleOpenApiAttachment(ChatAttachment att) async {
    openApiAttachmentCalls.add(att);
  }
}

class RecordingDashbotWindowNotifier extends DashbotWindowNotifier {
  int hideCalls = 0;
  int showCalls = 0;

  @override
  void hide() {
    hideCalls += 1;
    super.hide();
  }

  @override
  void show() {
    showCalls += 1;
    super.show();
  }
}
