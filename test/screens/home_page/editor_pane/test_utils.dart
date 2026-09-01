import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:apidash/dashbot/providers/providers.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:apidash/dashbot/constants.dart';

export '../../../providers/helpers.dart'
    show MockActiveCollectionNotifier, mockActiveCollectionOverrides;

class DummyChatViewmodel extends ChatViewmodel {
  DummyChatViewmodel(super.ref);

  @override
  List<ChatMessage> get currentMessages => [];

  @override
  Future<void> sendMessage({
    required String text,
    ChatMessageType type = ChatMessageType.general,
    bool countAsUser = true,
  }) async {}

  @override
  void clearCurrentChat() {}
}

class MockEnvironmentsStateNotifier
    extends StateNotifier<Map<String, EnvironmentModel>?>
    implements EnvironmentsStateNotifier {
  MockEnvironmentsStateNotifier(Map<String, EnvironmentModel>? state)
    : super(state);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
