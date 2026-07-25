import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';

Map<String, dynamic> encodeWorkflowRequest(RequestModel model) {
  final cleaned = model.copyWith(
    httpResponseModel: null,
    responseStatus: null,
    message: null,
    isWorking: false,
    isStreaming: false,
    sendingTime: null,
  );
  final json = <String, dynamic>{
    'id': cleaned.id,
  };
  if (cleaned.apiType != APIType.rest) {
    json['apiType'] = cleaned.apiType.name;
  }
  if (cleaned.name.isNotEmpty) {
    json['name'] = cleaned.name;
  }
  if (cleaned.description.isNotEmpty) {
    json['description'] = cleaned.description;
  }
  final pre = cleaned.preRequestScript?.trim() ?? '';
  if (pre.isNotEmpty) {
    json['preRequestScript'] = cleaned.preRequestScript;
  }
  final post = cleaned.postRequestScript?.trim() ?? '';
  if (post.isNotEmpty) {
    json['postRequestScript'] = cleaned.postRequestScript;
  }
  final http = cleaned.httpRequestModel;
  if (http != null) {
    final slimHttp = _slimHttpRequest(http);
    if (slimHttp.isNotEmpty) {
      json['httpRequestModel'] = slimHttp;
    }
  }
  final ai = cleaned.aiRequestModel;
  if (ai != null && cleaned.apiType == APIType.ai) {
    json['aiRequestModel'] = ai.toJson();
  }
  return json;
}

RequestModel decodeWorkflowRequest(Map<String, dynamic> json) {
  final normalized = Map<String, dynamic>.from(json);
  normalized.putIfAbsent('id', () => '');
  return RequestModel.fromJson(Map<String, Object?>.from(normalized));
}

Map<String, dynamic> _slimHttpRequest(HttpRequestModel http) {
  final full = Map<String, dynamic>.from(http.toJson());
  full.removeWhere((key, value) {
    if (value == null) {
      return true;
    }
    if (value is String && value.isEmpty) {
      return true;
    }
    if (value is List && value.isEmpty) {
      return true;
    }
    if (value is Map && value.isEmpty) {
      return true;
    }
    return false;
  });
  return full;
}
