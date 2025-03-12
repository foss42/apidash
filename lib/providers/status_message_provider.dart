import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/utils/status_validator.dart';

enum StatusMessageType { defaultType, info, warning, error }

class StatusMessage {
  final String message;
  final StatusMessageType type;

  StatusMessage(this.message, this.type);
}

final statusMessageProvider =
    StateNotifierProvider<GlobalStatusBarManager, StatusMessage>((ref) {
  return GlobalStatusBarManager(ref);
});

class GlobalStatusBarManager extends StateNotifier<StatusMessage> {
  final Ref ref;

  GlobalStatusBarManager(this.ref)
      : super(StatusMessage("Global Status Bar", StatusMessageType.defaultType)) {
    // Listen for request changes and validate
    ref.listen(selectedRequestModelProvider, (previous, next) {
      final method = next?.httpRequestModel?.method ?? HTTPVerb.get;
      final body = next?.httpRequestModel?.body;
      _updateStatusMessage(StatusValidator().validateRequest(method, body));
    });
  }

  // Updates the status message
  void _updateStatusMessage(StatusMessage newMessage) {
    state = newMessage;
  }
}
