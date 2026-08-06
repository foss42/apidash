import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:apidash/dashbot/services/services.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/models/ws_request_model.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

void main() {
  group('AutoFixService field & header updates', () {
    late HttpRequestModel http;
    late RequestModel reqModel;
    late AutoFixService auto;
    final urlEnv = UrlEnvService();
    final requestApply = RequestApplyService(urlEnv: urlEnv);
    String? lastSystemMessage;

    setUp(() {
      http = const HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/users',
        headers: [NameValueModel(name: 'Accept', value: 'application/json')],
        isHeaderEnabledList: [true],
      );
      reqModel = RequestModel(id: 'r1', httpRequestModel: http, name: 'Req');
      auto = AutoFixService(
        requestApply: requestApply,
        updateSelected:
            ({
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
            }) {
              var h = http.headers;
              if (headers != null) h = headers;
              http = http.copyWith(
                method: method ?? http.method,
                url: url ?? http.url,
                headers: h,
                body: body ?? http.body,
                formData: formData ?? http.formData,
                params: params ?? http.params,
              );
              reqModel = reqModel.copyWith(httpRequestModel: http);
            },
        addNewRequest: (_, {name}) {},
        readCurrentRequestId: () => 'r1',
        ensureBaseUrl: (b) async => 'BASE_URL_API_APIDASH_DEV',
        readCurrentRequest: () => reqModel,
      );
    });

    test('updateField url', () async {
      await auto.apply(
        const ChatAction(
          action: 'update_field',
          target: 'httpRequestModel',
          field: 'url',
          value: 'https://api.apidash.dev/items',
          actionType: ChatActionType.updateField,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(http.url, 'https://api.apidash.dev/items');
    });

    test('addHeader + updateHeader + deleteHeader', () async {
      // add
      await auto.apply(
        const ChatAction(
          action: 'add_header',
          target: 'httpRequestModel',
          path: 'X-Test',
          value: '1',
          actionType: ChatActionType.addHeader,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(http.headersMap.containsKey('X-Test'), true);
      // update
      await auto.apply(
        const ChatAction(
          action: 'update_header',
          target: 'httpRequestModel',
          path: 'X-Test',
          value: '2',
          actionType: ChatActionType.updateHeader,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(http.headersMap['X-Test'], '2');
      // delete
      await auto.apply(
        const ChatAction(
          action: 'delete_header',
          target: 'httpRequestModel',
          path: 'X-Test',
          value: '',
          actionType: ChatActionType.deleteHeader,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(http.headersMap.containsKey('X-Test'), false);
    });

    test('updateHeader adds when missing (fallback branch)', () async {
      // path does not exist yet -> should add
      await auto.apply(
        const ChatAction(
          action: 'update_header',
          target: 'httpRequestModel',
          path: 'X-Added',
          value: 'abc',
          actionType: ChatActionType.updateHeader,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(http.headersMap['X-Added'], 'abc');
    });

    test('updateBody actionType.updateBody', () async {
      await auto.apply(
        const ChatAction(
          action: 'update_body',
          target: 'httpRequestModel',
          value: '{"a":1}',
          actionType: ChatActionType.updateBody,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(http.body, '{"a":1}');
    });

    test('updateUrl actionType.updateUrl', () async {
      await auto.apply(
        const ChatAction(
          action: 'update_url',
          target: 'httpRequestModel',
          value: 'https://api.apidash.dev/changed',
          actionType: ChatActionType.updateUrl,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(http.url, 'https://api.apidash.dev/changed');
    });

    test('updateMethod actionType.updateMethod', () async {
      await auto.apply(
        const ChatAction(
          action: 'update_method',
          target: 'httpRequestModel',
          value: 'post',
          actionType: ChatActionType.updateMethod,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(http.method, HTTPVerb.post);
    });

    test('params update', () async {
      await auto.apply(
        const ChatAction(
          action: 'update_field',
          target: 'httpRequestModel',
          field: 'params',
          value: {'limit': '5'},
          actionType: ChatActionType.updateField,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(http.paramsMap['limit'], '5');
    });

    test('applyCurl dispatches to requestApply', () async {
      lastSystemMessage = await auto.apply(
        const ChatAction(
          action: 'apply_curl',
          target: 'httpRequestModel',
          field: 'apply_to_new',
          value: {
            'method': 'POST',
            'url': 'https://api.apidash.dev/new',
            'headers': {'Accept': 'application/json'},
          },
          actionType: ChatActionType.applyCurl,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(lastSystemMessage, contains('cURL'));
    });

    test('applyOpenApi dispatches to requestApply', () async {
      final msg = await auto.apply(
        const ChatAction(
          action: 'apply_openapi',
          target: 'httpRequestModel',
          field: 'apply_to_new',
          path: '/users',
          value: {
            'method': 'get',
            'url': 'https://api.apidash.dev/users',
            'baseUrl': 'https://api.apidash.dev',
            'headers': {'Accept': 'application/json'},
          },
          actionType: ChatActionType.applyOpenApi,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(msg, contains('OpenAPI'));
    });

    test('applyCurl with non-map value uses empty payload branch', () async {
      lastSystemMessage = await auto.apply(
        const ChatAction(
          action: 'apply_curl',
          target: 'httpRequestModel',
          field: 'apply_to_new',
          value: 'not-a-map', // triggers else path building empty map
          actionType: ChatActionType.applyCurl,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(lastSystemMessage, contains('cURL'));
    });

    test('applyOpenApi with non-map value uses empty payload branch', () async {
      final msg = await auto.apply(
        const ChatAction(
          action: 'apply_openapi',
          target: 'httpRequestModel',
          field: 'apply_to_new',
          path: '/users',
          value: 42, // non-map
          actionType: ChatActionType.applyOpenApi,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(msg, contains('OpenAPI'));
    });

    test('updateField method branch + unknown fallback', () async {
      // valid method
      await auto.apply(
        const ChatAction(
          action: 'update_field',
          target: 'httpRequestModel',
          field: 'method',
          value: 'POST',
          actionType: ChatActionType.updateField,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(http.method, HTTPVerb.post);
      // unknown -> fallback to GET
      await auto.apply(
        const ChatAction(
          action: 'update_field',
          target: 'httpRequestModel',
          field: 'method',
          value: 'NOTREAL',
          actionType: ChatActionType.updateField,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(http.method, HTTPVerb.get);
    });

    test('updateMethod fallback branch with unknown method', () async {
      // first set to POST so change back to GET is observable
      http = http.copyWith(method: HTTPVerb.post);
      await auto.apply(
        const ChatAction(
          action: 'update_method',
          target: 'httpRequestModel',
          value: 'WHATEVER', // not a valid verb -> fallback
          actionType: ChatActionType.updateMethod,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(http.method, HTTPVerb.get);
    });

    test('no-op action types return null', () async {
      final types = [
        ChatActionType.other,
        ChatActionType.showLanguages,
        ChatActionType.noAction,
        ChatActionType.uploadAsset,
        ChatActionType.downloadDoc,
      ];
      for (final t in types) {
        final res = await auto.apply(
          ChatAction(
            action: 'noop',
            target: 'httpRequestModel',
            actionType: t,
            targetType: ChatActionTarget.httpRequestModel,
          ),
        );
        expect(res, isNull);
      }
    });

    test('early return when requestId null (updateField)', () async {
      // Create a new service with null requestId provider to hit early return branch
      final autoNull = AutoFixService(
        requestApply: requestApply,
        updateSelected:
            ({
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
            }) {
              fail('Should not be called when requestId is null');
            },
        addNewRequest: (_, {name}) {},
        readCurrentRequestId: () => null,
        ensureBaseUrl: (b) async => 'BASE_URL_API_APIDASH_DEV',
        readCurrentRequest: () => reqModel,
      );
      // Should silently do nothing
      final res = await autoNull.apply(
        const ChatAction(
          action: 'update_field',
          target: 'httpRequestModel',
          field: 'url',
          value: 'https://api.apidash.dev/new',
          actionType: ChatActionType.updateField,
          targetType: ChatActionTarget.httpRequestModel,
        ),
      );
      expect(res, isNull);
    });
  });

  group('AutoFixService WebSocket apply', () {
    final urlEnv = UrlEnvService();
    final requestApply = RequestApplyService(urlEnv: urlEnv);

    late RequestModel wsReqModel;
    late List<({String id, String url})> updateWsUrlCalls;
    late int updateSelectedCalls;
    List<NameValueModel>? lastHeaders;
    List<bool>? lastIsHeaderEnabledList;

    AutoFixService buildService({bool withUpdateWsUrl = true}) {
      return AutoFixService(
        requestApply: requestApply,
        updateSelected:
            ({
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
            }) {
              updateSelectedCalls++;
              lastHeaders = headers;
              lastIsHeaderEnabledList = isHeaderEnabledList;
            },
        addNewRequest: (_, {name}) {},
        readCurrentRequestId: () => 'ws1',
        ensureBaseUrl: (b) async => b,
        readCurrentRequest: () => wsReqModel,
        updateWsUrl: withUpdateWsUrl
            ? ({required String id, required String url}) {
                updateWsUrlCalls.add((id: id, url: url));
              }
            : null,
      );
    }

    setUp(() {
      updateWsUrlCalls = [];
      updateSelectedCalls = 0;
      lastHeaders = null;
      lastIsHeaderEnabledList = null;
      // Decisive fixture: NO httpRequestModel, so header reads can only
      // succeed if they come from wsRequestModel.headers.
      wsReqModel = RequestModel(
        id: 'ws1',
        name: 'WS Req',
        apiType: APIType.websocket,
        wsRequestModel: const WebSocketRequestModel(
          url: 'ws://api.apidash.dev/ws/echo',
          headers: [NameValueModel(name: 'X-Existing', value: 'old')],
          isHeaderEnabledList: [true],
        ),
      );
    });

    test(
      'update_url routes to updateWsUrl, updateSelected untouched',
      () async {
        final auto = buildService();
        await auto.apply(
          const ChatAction(
            action: 'update_url',
            target: 'wsRequestModel',
            field: 'url',
            value: 'wss://api.apidash.dev/ws/echo',
            actionType: ChatActionType.updateUrl,
            targetType: ChatActionTarget.wsRequestModel,
          ),
        );
        expect(updateWsUrlCalls, [(id: 'ws1', url: 'wss://api.apidash.dev/ws/echo')]);
        expect(updateSelectedCalls, 0);
      },
    );

    test(
      'update_url without an injected updateWsUrl is a safe no-op',
      () async {
        final auto = buildService(withUpdateWsUrl: false);
        await auto.apply(
          const ChatAction(
            action: 'update_url',
            target: 'wsRequestModel',
            field: 'url',
            value: 'wss://api.apidash.dev/ws/echo',
            actionType: ChatActionType.updateUrl,
            targetType: ChatActionTarget.wsRequestModel,
          ),
        );
        // The HTTP url path must never run for a WS request.
        expect(updateSelectedCalls, 0);
      },
    );

    test('add_header reads existing headers from wsRequestModel', () async {
      final auto = buildService();
      await auto.apply(
        const ChatAction(
          action: 'add_header',
          target: 'wsRequestModel',
          path: 'Authorization',
          value: 'Bearer your_access_token',
          actionType: ChatActionType.addHeader,
          targetType: ChatActionTarget.wsRequestModel,
        ),
      );
      expect(updateSelectedCalls, 1);
      expect(lastHeaders, isNotNull);
      expect(lastHeaders!.map((h) => h.name), ['X-Existing', 'Authorization']);
      expect(lastHeaders!.last.value, 'Bearer your_access_token');
      expect(lastIsHeaderEnabledList, [true, true]);
      expect(updateWsUrlCalls, isEmpty);
    });

    test('update_header and delete_header use the ws read side', () async {
      final auto = buildService();
      await auto.apply(
        const ChatAction(
          action: 'update_header',
          target: 'wsRequestModel',
          path: 'X-Existing',
          value: 'new-value',
          actionType: ChatActionType.updateHeader,
          targetType: ChatActionTarget.wsRequestModel,
        ),
      );
      expect(updateSelectedCalls, 1);
      expect(lastHeaders!.single.name, 'X-Existing');
      expect(lastHeaders!.single.value, 'new-value');

      await auto.apply(
        const ChatAction(
          action: 'delete_header',
          target: 'wsRequestModel',
          path: 'X-Existing',
          value: '',
          actionType: ChatActionType.deleteHeader,
          targetType: ChatActionTarget.wsRequestModel,
        ),
      );
      expect(updateSelectedCalls, 2);
      expect(lastHeaders, isEmpty);
    });

    test('WS request without wsRequestModel skips header updates', () async {
      wsReqModel = RequestModel(id: 'ws1', apiType: APIType.websocket);
      final auto = buildService();
      await auto.apply(
        const ChatAction(
          action: 'add_header',
          target: 'wsRequestModel',
          path: 'Authorization',
          value: 'Bearer x',
          actionType: ChatActionType.addHeader,
          targetType: ChatActionTarget.wsRequestModel,
        ),
      );
      expect(updateSelectedCalls, 0);
    });
  });
}
