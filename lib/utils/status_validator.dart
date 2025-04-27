import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'dart:convert';

class StatusValidator {
  StatusMessage validateRequest(HTTPVerb method, String? body, {ContentType? contentType}) {
    // Check for GET requests with body
    if (_isInvalidGetRequest(method, body)) {
      return StatusMessage(
        "GET requests cannot have a body. Remove the body or change the method to POST.",
        StatusMessageType.warning,
      );
    }

    //simple check for JSON validation for testing
    if (contentType == ContentType.json && body != null && body.isNotEmpty) {
      final jsonValidation = _validateJson(body);
      if (jsonValidation != null) {
        return jsonValidation;
      }
    }

    return StatusMessage(kStatusBarDefaultMessage, StatusMessageType.defaultType);
  }

  bool _isInvalidGetRequest(HTTPVerb method, String? body) {
    return method == HTTPVerb.get && body != null && body.isNotEmpty;
  }
  
  StatusMessage? _validateJson(String jsonText) {
    if (jsonText.trim().isEmpty) return null;
    
    try {
      json.decode(jsonText);
      return null; // Valid JSON
    } catch (e) {
      // Extract the error message
      final errorMsg = e.toString();
      final simplifiedError = errorMsg.contains('FormatException') 
          ? 'Invalid JSON: ${errorMsg.split('FormatException: ').last}'
          : 'Invalid JSON format';
          
      return StatusMessage(
        simplifiedError,
        StatusMessageType.error,
      );
    }
  }
}