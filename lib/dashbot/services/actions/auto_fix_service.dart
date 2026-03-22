import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import '../../constants.dart';
import '../../models/models.dart';
import 'request_apply_service.dart';

class AutoFixService {
  AutoFixService({
    required this.requestApply,
    required this.updateSelected,
    required this.addNewRequest,
    required this.readCurrentRequestId,
    required this.ensureBaseUrl,
    required this.readCurrentRequest,
  });

  final RequestApplyService requestApply;
  final UpdateSelectedFn updateSelected;
  final AddNewRequestFn addNewRequest;
  final String? Function() readCurrentRequestId;
  final Future<String> Function(String baseUrl) ensureBaseUrl;
  final RequestModel? Function() readCurrentRequest;

  Future<String?> apply(ChatAction action) async {
    final requestId = readCurrentRequestId();
    switch (action.actionType) {
      case ChatActionType.updateField:
        await _applyFieldUpdate(action, requestId);
        return null;
      case ChatActionType.addHeader:
        await _applyHeaderUpdate(action, isAdd: true, requestId: requestId);
        return null;
      case ChatActionType.updateHeader:
        await _applyHeaderUpdate(action, isAdd: false, requestId: requestId);
        return null;
      case ChatActionType.deleteHeader:
        await _applyHeaderDelete(action, requestId);
        return null;
      case ChatActionType.updateBody:
        await _applyBodyUpdate(action, requestId);
        return null;
      case ChatActionType.updateUrl:
        await _applyUrlUpdate(action, requestId);
        return null;
      case ChatActionType.updateMethod:
        await _applyMethodUpdate(action, requestId);
        return null;
      case ChatActionType.applyCurl:
        {
          final payload = (action.value is Map<String, dynamic>)
              ? (action.value as Map<String, dynamic>)
              : <String, dynamic>{};
          final res = await requestApply.applyCurl(
            payload: payload,
            target: action.field,
            requestId: requestId,
            updateSelected: updateSelected,
            addNewRequest: addNewRequest,
            ensureBaseUrl: ensureBaseUrl,
          );
          return res?.systemMessage;
        }
      case ChatActionType.applyOpenApi:
        {
          final payload = (action.value is Map<String, dynamic>)
              ? (action.value as Map<String, dynamic>)
              : <String, dynamic>{};
          final res = await requestApply.applyOpenApi(
            payload: payload,
            field: action.field,
            path: action.path,
            requestId: requestId,
            updateSelected: updateSelected,
            addNewRequest: addNewRequest,
            ensureBaseUrl: ensureBaseUrl,
          );
          return res?.systemMessage;
        }
      case ChatActionType.other:
        // defer to specific target logic if needed
        return null;
      case ChatActionType.showLanguages:
      case ChatActionType.noAction:
      case ChatActionType.uploadAsset:
      case ChatActionType.downloadDoc:
        return null;
    }
  }

  Future<void> _applyFieldUpdate(ChatAction action, String? requestId) async {
    if (requestId == null) return;
    switch (action.field) {
      case 'url':
        updateSelected(id: requestId, url: action.value as String);
        break;
      case 'method':
        final method = HTTPVerb.values.firstWhere(
          (m) => m.name.toLowerCase() == (action.value as String).toLowerCase(),
          orElse: () => HTTPVerb.get,
        );
        updateSelected(id: requestId, method: method);
        break;
      case 'params':
        if (action.value is Map<String, dynamic>) {
          final params = (action.value as Map<String, dynamic>)
              .entries
              .map((e) => NameValueModel(
                    name: e.key,
                    value: e.value.toString(),
                  ))
              .toList();
          final enabled = List<bool>.filled(params.length, true);
          updateSelected(
            id: requestId,
            params: params,
            isParamEnabledList: enabled,
          );
        }
        break;
    }
  }

  Future<void> _applyHeaderUpdate(ChatAction action,
      {required bool isAdd, String? requestId}) async {
    if (requestId == null || action.path == null) return;
    final current = readCurrentRequest();
    final http = current?.httpRequestModel;
    if (http == null) return;

    final headers = List<NameValueModel>.from(http.headers ?? const []);
    if (isAdd) {
      headers.add(
          NameValueModel(name: action.path!, value: action.value as String));
    } else {
      final index = headers.indexWhere((h) => h.name == action.path);
      if (index != -1) {
        headers[index] = headers[index].copyWith(value: action.value as String);
      } else {
        headers.add(
            NameValueModel(name: action.path!, value: action.value as String));
      }
    }

    updateSelected(
      id: requestId,
      headers: headers,
      isHeaderEnabledList: List<bool>.filled(headers.length, true),
    );
  }

  Future<void> _applyHeaderDelete(ChatAction action, String? requestId) async {
    if (requestId == null || action.path == null) return;
    final current = readCurrentRequest();
    final http = current?.httpRequestModel;
    if (http == null) return;

    final headers = List<NameValueModel>.from(http.headers ?? const []);
    headers.removeWhere((h) => h.name == action.path);
    updateSelected(
      id: requestId,
      headers: headers,
      isHeaderEnabledList: List<bool>.filled(headers.length, true),
    );
  }

  Future<void> _applyBodyUpdate(ChatAction action, String? requestId) async {
    if (requestId == null) return;
    updateSelected(id: requestId, body: action.value as String);
  }

  Future<void> _applyUrlUpdate(ChatAction action, String? requestId) async {
    if (requestId == null) return;
    updateSelected(id: requestId, url: action.value as String);
  }

  Future<void> _applyMethodUpdate(ChatAction action, String? requestId) async {
    if (requestId == null) return;
    final method = HTTPVerb.values.firstWhere(
      (m) => m.name.toLowerCase() == (action.value as String).toLowerCase(),
      orElse: () => HTTPVerb.get,
    );
    updateSelected(id: requestId, method: method);
  }
}
