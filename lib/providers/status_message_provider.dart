import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/utils/status_validator.dart';
import 'package:apidash/consts.dart';

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
  final StatusValidator _validator = StatusValidator();

  GlobalStatusBarManager(this.ref)
      : super(StatusMessage(kStatusBarDefaultMessage, StatusMessageType.defaultType)) {
    ref.listen(selectedRequestModelProvider, (previous, next) {
      if (next?.httpRequestModel != null) {
        final httpModel = next!.httpRequestModel!;
        final method = httpModel.method;
        final body = httpModel.body;
        final contentType = httpModel.bodyContentType;

        final newMessage = _validator.validateRequest(method, body, contentType: contentType);
        // Only update if the new message is different
        if (newMessage.message != state.message || newMessage.type != state.type) {
          _updateStatusMessage(newMessage);
        }
      } else {
        _resetStatusMessage();
      }
    });
  }

  void _updateStatusMessage(StatusMessage newMessage) {     // Updates the status message
    state = newMessage;
  }

  void _resetStatusMessage() {
    state = StatusMessage(kStatusBarDefaultMessage, StatusMessageType.defaultType);
  }
}