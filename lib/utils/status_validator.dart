import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/status_message_provider.dart'; 
import 'package:apidash_design_system/apidash_design_system.dart';

class StatusValidator {
  StatusMessage validateRequest(HTTPVerb method, String? body) {
    if (_isInvalidGetRequest(method, body)) {
      return StatusMessage(
        "GET requests cannot have a body. Remove the body or change the method to POST.",
        StatusMessageType.info,
      );
    }
    return StatusMessage("Global Status Bar", StatusMessageType.defaultType);
  }

  bool _isInvalidGetRequest(HTTPVerb method, String? body) {
    return method == HTTPVerb.get && body != null && body.isNotEmpty;
  }

}
