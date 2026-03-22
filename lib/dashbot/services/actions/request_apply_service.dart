import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import '../../constants.dart';
import '../base/url_env_service.dart';

class ApplyResult {
  final String? systemMessage;
  final ChatMessageType? messageType;
  const ApplyResult({this.systemMessage, this.messageType});
}

typedef UpdateSelectedFn = void Function({
  required String id,
  HTTPVerb? method,
  String? url,
  List<NameValueModel>? headers,
  List<bool>? isHeaderEnabledList,
  String? body,
  ContentType? bodyContentType,
  List<FormDataModel>? formData,
  List<NameValueModel>? params,
  List<bool>? isParamEnabledList,
  String? postRequestScript,
});

typedef AddNewRequestFn = void Function(HttpRequestModel model, {String? name});

class RequestApplyService {
  RequestApplyService({required this.urlEnv});

  final UrlEnvService urlEnv;

  Future<ApplyResult?> applyCurl({
    required Map<String, dynamic> payload,
    required String? target, // 'apply_to_selected' | 'apply_to_new'
    required String? requestId,
    required UpdateSelectedFn updateSelected,
    required AddNewRequestFn addNewRequest,
    required Future<String> Function(String baseUrl) ensureBaseUrl,
  }) async {
    String methodStr = (payload['method'] as String?)?.toLowerCase() ?? 'get';
    final method = HTTPVerb.values.firstWhere(
      (m) => m.name == methodStr,
      orElse: () => HTTPVerb.get,
    );
    final url = payload['url'] as String? ?? '';
    final baseUrl = urlEnv.inferBaseUrl(url);

    final headersMap =
        (payload['headers'] as Map?)?.cast<String, dynamic>() ?? {};
    final headers = headersMap.entries
        .map((e) => NameValueModel(name: e.key, value: e.value.toString()))
        .toList();

    final body = payload['body'] as String?;
    final formFlag = payload['form'] == true;
    final formDataListRaw = (payload['formData'] as List?)?.cast<dynamic>();
    final formData = formDataListRaw == null
        ? <FormDataModel>[]
        : formDataListRaw
            .whereType<Map>()
            .map((e) => FormDataModel(
                  name: (e['name'] as String?) ?? '',
                  value: (e['value'] as String?) ?? '',
                  type: (() {
                    final t = (e['type'] as String?) ?? 'text';
                    try {
                      return FormDataType.values
                          .firstWhere((ft) => ft.name == t);
                    } catch (_) {
                      return FormDataType.text;
                    }
                  })(),
                ))
            .toList();

    ContentType bodyContentType;
    if (formFlag || formData.isNotEmpty) {
      bodyContentType = ContentType.formdata;
    } else if ((body ?? '').trim().isEmpty) {
      bodyContentType = ContentType.text;
    } else {
      try {
        jsonDecode(body!);
        bodyContentType = ContentType.json;
      } catch (_) {
        bodyContentType = ContentType.text;
      }
    }

    final withEnvUrl = await urlEnv.maybeSubstituteBaseUrl(
      url,
      baseUrl,
      ensure: ensureBaseUrl,
    );

    if (target == 'apply_to_selected') {
      if (requestId == null) return null;
      updateSelected(
        id: requestId,
        method: method,
        url: withEnvUrl,
        headers: headers,
        isHeaderEnabledList: List<bool>.filled(headers.length, true),
        body: body,
        bodyContentType: bodyContentType,
        formData: formData.isEmpty ? null : formData,
        params: const [],
        isParamEnabledList: const [],
      );
      return const ApplyResult(
        systemMessage: 'Applied cURL to the selected request.',
        messageType: ChatMessageType.importCurl,
      );
    } else if (target == 'apply_to_new') {
      final model = HttpRequestModel(
        method: method,
        url: withEnvUrl,
        headers: headers,
        isHeaderEnabledList: List<bool>.filled(headers.length, true),
        body: body,
        bodyContentType: bodyContentType,
        formData: formData.isEmpty ? null : formData,
      );
      addNewRequest(model, name: 'Imported cURL');
      return const ApplyResult(
        systemMessage: 'Created a new request from the cURL.',
        messageType: ChatMessageType.importCurl,
      );
    }
    return null;
  }

  Future<ApplyResult?> applyOpenApi({
    required Map<String, dynamic> payload,
    required String?
        field, // 'apply_to_selected'|'apply_to_new'|'select_operation'
    required String? path,
    required String? requestId,
    required UpdateSelectedFn updateSelected,
    required AddNewRequestFn addNewRequest,
    required Future<String> Function(String baseUrl) ensureBaseUrl,
  }) async {
    String methodStr = (payload['method'] as String?)?.toLowerCase() ?? 'get';
    final method = HTTPVerb.values.firstWhere(
      (m) => m.name == methodStr,
      orElse: () => HTTPVerb.get,
    );
    final url = payload['url'] as String? ?? '';
    final baseUrl = payload['baseUrl'] as String? ?? urlEnv.inferBaseUrl(url);

    String routePath;
    if (baseUrl.isNotEmpty && url.startsWith(baseUrl)) {
      routePath = url.substring(baseUrl.length);
    } else {
      try {
        final u = Uri.parse(url);
        routePath = u.path.isEmpty ? '/' : u.path;
      } catch (_) {
        routePath = url;
      }
    }
    if (!routePath.startsWith('/')) routePath = '/$routePath';

    final headersMap =
        (payload['headers'] as Map?)?.cast<String, dynamic>() ?? {};
    final headers = headersMap.entries
        .map((e) => NameValueModel(name: e.key, value: e.value.toString()))
        .toList();

    final body = payload['body'] as String?;
    final formFlag = payload['form'] == true;
    final formDataListRaw = (payload['formData'] as List?)?.cast<dynamic>();
    final formData = formDataListRaw == null
        ? <FormDataModel>[]
        : formDataListRaw
            .whereType<Map>()
            .map((e) => FormDataModel(
                  name: (e['name'] as String?) ?? '',
                  value: (e['value'] as String?) ?? '',
                  type: (() {
                    final t = (e['type'] as String?) ?? 'text';
                    try {
                      return FormDataType.values
                          .firstWhere((ft) => ft.name == t);
                    } catch (_) {
                      return FormDataType.text;
                    }
                  })(),
                ))
            .toList();

    ContentType bodyContentType;
    if (formFlag || formData.isNotEmpty) {
      bodyContentType = ContentType.formdata;
    } else if ((body ?? '').trim().isEmpty) {
      bodyContentType = ContentType.text;
    } else {
      try {
        jsonDecode(body!);
        bodyContentType = ContentType.json;
      } catch (_) {
        bodyContentType = ContentType.text;
      }
    }

    final withEnvUrl = await urlEnv.maybeSubstituteBaseUrl(
      url,
      baseUrl,
      ensure: ensureBaseUrl,
    );

    if (field == 'apply_to_selected') {
      if (requestId == null) return null;
      updateSelected(
        id: requestId,
        method: method,
        url: withEnvUrl,
        headers: headers,
        isHeaderEnabledList: List<bool>.filled(headers.length, true),
        body: body,
        bodyContentType: bodyContentType,
        formData: formData.isEmpty ? null : formData,
        // Wipe existing parameters and authentication to ensure clean state
        params: const [],
        isParamEnabledList: const [],
      );
      return const ApplyResult(
        systemMessage: 'Applied OpenAPI operation to the selected request.',
        messageType: ChatMessageType.importOpenApi,
      );
    } else if (field == 'apply_to_new') {
      final model = HttpRequestModel(
        method: method,
        url: withEnvUrl,
        headers: headers,
        isHeaderEnabledList: List<bool>.filled(headers.length, true),
        body: body,
        bodyContentType: bodyContentType,
        formData: formData.isEmpty ? null : formData,
      );
      final displayName = '${method.name.toUpperCase()} $routePath';
      addNewRequest(model, name: displayName);
      return const ApplyResult(
        systemMessage: 'Created a new request from the OpenAPI operation.',
        messageType: ChatMessageType.importOpenApi,
      );
    } else if (field == 'select_operation') {
      // UI presents options elsewhere; no system message here.
      return const ApplyResult();
    }
    return null;
  }
}
