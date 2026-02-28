import 'package:apidash/dashbot/services/services.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

void main() {
  group('RequestApplyService.applyCurl', () {
    final urlEnv = UrlEnvService();
    final service = RequestApplyService(urlEnv: urlEnv);
    Map<String, dynamic>? lastUpdate;
    HttpRequestModel? newModel;
    ApplyResult? result;

    setUp(() {
      lastUpdate = null;
      newModel = null;
      result = null;
    });

    test('apply to selected', () async {
      result = await service.applyCurl(
        payload: {
          'method': 'POST',
          'url': 'https://api.apidash.dev/users',
          'headers': {'Content-Type': 'application/json'},
          'body': '{"x":1}',
        },
        target: 'apply_to_selected',
        requestId: 'r1',
        updateSelected: ({
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
          lastUpdate = {
            'id': id,
            'method': method,
            'url': url,
            'headers': headers,
            'body': body,
            'bodyContentType': bodyContentType,
          };
        },
        addNewRequest: (model, {name}) => newModel = model,
        ensureBaseUrl: (b) async => 'BASE_URL_API_APIDASH_DEV',
      );
      expect(result!.systemMessage, contains('Applied cURL'));
      expect(lastUpdate!['method'], HTTPVerb.post);
      expect(lastUpdate!['url'], contains('{{BASE_URL_')); // substituted
    });

    test('apply to new builds HttpRequestModel', () async {
      result = await service.applyCurl(
        payload: {
          'method': 'GET',
          'url': 'https://api.apidash.dev/items?size=2',
          'headers': {'Accept': 'application/json'},
          'body': null,
        },
        target: 'apply_to_new',
        requestId: 'r1',
        updateSelected: ({
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
        }) {},
        addNewRequest: (model, {name}) => newModel = model,
        ensureBaseUrl: (b) async => 'BASE_URL_API_APIDASH_DEV',
      );
      expect(result!.systemMessage, contains('Created a new request'));
      expect(newModel, isNotNull);
      expect(newModel!.url, contains('{{BASE_URL_'));
    });

    test('apply_to_new with formData mapping & fallback type', () async {
      result = await service.applyCurl(
        payload: {
          'method': 'POST',
          'url': 'https://api.apidash.dev/upload',
          'headers': {'Accept': 'application/json'},
          'form': true,
          'formData': [
            {'name': 'field1', 'value': 'v1', 'type': 'text'},
            {
              'name': 'field2',
              'value': 'v2',
              'type': 'unknownType'
            }, // fallback
            'not-a-map',
          ],
        },
        target: 'apply_to_new',
        requestId: 'r1',
        updateSelected: ({
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
        }) {},
        addNewRequest: (model, {name}) => newModel = model,
        ensureBaseUrl: (b) async => 'BASE_URL_API_APIDASH_DEV',
      );
      expect(result!.systemMessage, contains('Created a new request'));
      expect(newModel, isNotNull);
      expect(newModel!.bodyContentType, ContentType.formdata);
      // Two mapped entries only (string filtered out)
      expect(newModel!.formData?.length, 2);
      expect(newModel!.formData![1].type, FormDataType.text); // fallback
    });

    test('apply_to_selected with unknown method fallback + empty body -> text',
        () async {
      result = await service.applyCurl(
        payload: {
          'method': 'PATCHX', // unknown -> fallback to GET
          'url': 'https://api.apidash.dev/sel',
          'headers': {'X-Test': '1'},
          'body': '   ', // trimmed empty triggers text content type
        },
        target: 'apply_to_selected',
        requestId: 'sel1',
        updateSelected: ({
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
          lastUpdate = {
            'method': method,
            'bodyContentType': bodyContentType,
          };
        },
        addNewRequest: (_, {name}) {},
        ensureBaseUrl: (b) async => 'BASE_URL_API_APIDASH_DEV',
      );
      expect(result!.systemMessage, contains('Applied cURL'));
      expect(lastUpdate!['method'], HTTPVerb.get); // fallback
      expect(lastUpdate!['bodyContentType'], ContentType.text);
    });

    test('unknown target returns null', () async {
      final res = await service.applyCurl(
        payload: {
          'method': 'GET',
          'url': 'https://api.apidash.dev/none',
        },
        target: 'unrecognized',
        requestId: 'r1',
        updateSelected: ({
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
        }) {},
        addNewRequest: (_, {name}) {},
        ensureBaseUrl: (b) async => 'BASE_URL_API_APIDASH_DEV',
      );
      expect(res, isNull);
    });
  });

  group('RequestApplyService.applyOpenApi', () {
    final urlEnv = UrlEnvService();
    final service = RequestApplyService(urlEnv: urlEnv);
    HttpRequestModel? newModel;
    ApplyResult? result;

    test('apply_to_new', () async {
      result = await service.applyOpenApi(
        payload: {
          'method': 'get',
          'url': 'https://api.apidash.dev/users',
          'baseUrl': 'https://api.apidash.dev',
          'headers': {'Accept': 'application/json'},
        },
        field: 'apply_to_new',
        path: '/users',
        requestId: 'r1',
        updateSelected: ({
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
        }) {},
        addNewRequest: (model, {name}) => newModel = model,
        ensureBaseUrl: (b) async => 'BASE_URL_API_APIDASH_DEV',
      );
      expect(result!.systemMessage, contains('Created a new request'));
      expect(newModel!.url, contains('{{BASE_URL_'));
    });

    test('apply_to_selected with routePath else-branch, formData & json body',
        () async {
      Map<String, dynamic>? captured;
      result = await service.applyOpenApi(
        payload: {
          'method': 'CUSTOMVERB', // fallback to GET
          'url': 'https://api.apidash.dev/v1/users?id=1',
          'baseUrl':
              'https://different-base.dev', // does not match -> else branch
          'headers': {'Accept': 'application/json'},
          'body': '{"a":1}', // json detection path
          'formData': [
            {'name': 'f1', 'value': 'v1', 'type': 'text'},
            {
              'name': 'f2',
              'value': 'v2',
              'type': 'unknownType'
            }, // fallback type
          ],
        },
        field: 'apply_to_selected',
        path: '/v1/users',
        requestId: 'openSel1',
        updateSelected: ({
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
          captured = {
            'method': method,
            'url': url,
            'bodyType': bodyContentType,
            'formDataLen': formData?.length,
          };
        },
        addNewRequest: (_, {name}) {},
        ensureBaseUrl: (b) async => 'BASE_URL_API_APIDASH_DEV',
      );
      expect(result!.systemMessage, contains('Applied OpenAPI'));
      expect(captured!['method'], HTTPVerb.get); // fallback method
      // Since formData provided, content type should resolve to formdata (branch: formFlag/formData.isNotEmpty)
      expect(captured!['bodyType'], ContentType.formdata);
      expect(captured!['formDataLen'], 2);
    });

    test('apply_to_selected JSON body detection (no formData)', () async {
      Map<String, dynamic>? captured;
      result = await service.applyOpenApi(
        payload: {
          'method': 'get',
          'url': 'https://api.apidash.dev/users',
          'baseUrl': 'https://api.apidash.dev', // matches -> substring branch
          'headers': {'Accept': 'application/json'},
          'body': '{"hello":123}', // triggers json decode branch
        },
        field: 'apply_to_selected',
        path: '/users',
        requestId: 'openSel2',
        updateSelected: ({
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
          captured = {
            'bodyType': bodyContentType,
            'url': url,
          };
        },
        addNewRequest: (_, {name}) {},
        ensureBaseUrl: (b) async => 'BASE_URL_API_APIDASH_DEV',
      );
      expect(result!.systemMessage, contains('Applied OpenAPI'));
      expect(captured!['bodyType'], ContentType.json);
      expect(captured!['url'], contains('{{BASE_URL_'));
    });

    test('select_operation returns empty ApplyResult', () async {
      result = await service.applyOpenApi(
        payload: {
          'method': 'get',
          'url': 'https://api.apidash.dev/users',
          'baseUrl': 'https://api.apidash.dev',
        },
        field: 'select_operation',
        path: '/users',
        requestId: 'r1',
        updateSelected: ({
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
        }) {},
        addNewRequest: (_, {name}) {},
        ensureBaseUrl: (b) async => 'BASE_URL_API_APIDASH_DEV',
      );
      expect(result, isNotNull);
      expect(result!.systemMessage, isNull);
      expect(result!.messageType, isNull);
    });
  });
}
