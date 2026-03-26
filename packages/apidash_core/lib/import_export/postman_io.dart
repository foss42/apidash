import 'package:genai/genai.dart';
import 'package:postman/postman.dart' as pm;

class PostmanIO {
  List<(String?, HttpRequestModel)>? getHttpRequestModelList(String content) {
    content = content.trim();
    try {
      final pc = pm.postmanCollectionFromJsonStr(content);
      final variableMap = pm.buildVariableMap(pc.variable);
      final requests = pm.getRequestsFromPostmanCollection(pc);
      return requests
          .map((req) => (
                req.$1,
                postmanRequestToHttpRequestModel(req.$2, variableMap),
              ))
          .toList();
    } catch (e) {
      return null;
    }
  }

  HttpRequestModel postmanRequestToHttpRequestModel(
    pm.Request request, [
    Map<String, String> variableMap = const {},
  ]) {
    HTTPVerb method;

    try {
      method = HTTPVerb.values.byName((request.method ?? "").toLowerCase());
    } catch (e) {
      method = kDefaultHttpMethod;
    }
    String url =
        stripUrlParams(_substitute(request.url?.raw ?? '', variableMap));
    List<NameValueModel> headers = [];
    List<bool> isHeaderEnabledList = [];

    List<NameValueModel> params = [];
    List<bool> isParamEnabledList = [];

    for (var header in request.header ?? <pm.Header>[]) {
      var name = header.key ?? "";
      var value = _substituteNullable(header.value, variableMap);
      var activeHeader = header.disabled ?? false;
      headers.add(NameValueModel(name: name, value: value));
      isHeaderEnabledList.add(!activeHeader);
    }

    for (var query in request.url?.query ?? <pm.Query>[]) {
      var name = query.key ?? "";
      var value = _substituteNullable(query.value, variableMap);
      var activeQuery = query.disabled ?? false;
      params.add(NameValueModel(name: name, value: value));
      isParamEnabledList.add(!activeQuery);
    }

    ContentType bodyContentType = kDefaultContentType;
    String? body;
    List<FormDataModel>? formData;
    if (request.body != null) {
      if (request.body?.mode == 'raw') {
        try {
          bodyContentType = ContentType.values
              .byName(request.body?.options?.raw?.language ?? "");
        } catch (e) {
          bodyContentType = kDefaultContentType;
        }
        body = _substituteNullable(request.body?.raw, variableMap);
      }
      if (request.body?.mode == 'formdata') {
        bodyContentType = ContentType.formdata;
        formData = [];
        for (var fd in request.body?.formdata ?? <pm.Formdatum>[]) {
          var name = fd.key ?? "";
          FormDataType formDataType;
          try {
            formDataType = FormDataType.values.byName(fd.type ?? "");
          } catch (e) {
            formDataType = FormDataType.text;
          }
          var value = switch (formDataType) {
            FormDataType.text => _substitute(fd.value ?? '', variableMap),
            FormDataType.file => _substitute(fd.src ?? '', variableMap)
          };
          formData.add(FormDataModel(
            name: name,
            value: value,
            type: formDataType,
          ));
        }
      }
      if (request.body?.mode == 'urlencoded') {
        bodyContentType = ContentType.formdata;
        formData = [];
        for (var u in request.body?.urlencoded ?? <pm.Urlencoded>[]) {
          if (u.disabled ?? false) {
            continue;
          }
          formData.add(
            FormDataModel(
              name: u.key ?? '',
              value: _substitute(u.value ?? '', variableMap),
              type: FormDataType.text,
            ),
          );
        }
      }
    }

    final authModel = _mapAuthModel(request.auth, variableMap);

    return HttpRequestModel(
      method: method,
      url: url,
      headers: headers,
      params: params,
      isHeaderEnabledList: isHeaderEnabledList,
      isParamEnabledList: isParamEnabledList,
      authModel: authModel,
      body: body,
      bodyContentType: bodyContentType,
      formData: formData,
    );
  }

  String _substitute(String input, Map<String, String> variableMap) {
    if (variableMap.isEmpty) {
      return input;
    }
    return pm.substituteVariables(input, variableMap);
  }

  String? _substituteNullable(String? input, Map<String, String> variableMap) {
    if (input == null) {
      return null;
    }
    return _substitute(input, variableMap);
  }

  AuthModel _mapAuthModel(
    pm.PostmanAuth? auth,
    Map<String, String> variableMap,
  ) {
    if (auth == null) {
      return const AuthModel(type: APIAuthType.none);
    }
    switch ((auth.type ?? '').toLowerCase()) {
      case 'bearer':
        return AuthModel(
          type: APIAuthType.bearer,
          bearer: AuthBearerModel(
            token: _substitute(
                _getAuthValue(auth.bearer, 'token') ?? '', variableMap),
          ),
        );
      case 'basic':
        return AuthModel(
          type: APIAuthType.basic,
          basic: AuthBasicAuthModel(
            username: _substitute(
                _getAuthValue(auth.basic, 'username') ?? '', variableMap),
            password: _substitute(
                _getAuthValue(auth.basic, 'password') ?? '', variableMap),
          ),
        );
      case 'apikey':
        return AuthModel(
          type: APIAuthType.apiKey,
          apikey: AuthApiKeyModel(
            key: _substitute(
                _getAuthValue(auth.apikey, 'value') ?? '', variableMap),
            name: _substitute(
                _getAuthValue(auth.apikey, 'key') ?? 'x-api-key', variableMap),
            location: _substitute(
                _getAuthValue(auth.apikey, 'in') ?? 'header', variableMap),
          ),
        );
      default:
        return const AuthModel(type: APIAuthType.none);
    }
  }

  String? _getAuthValue(List<pm.AuthKeyValue>? values, String key) {
    for (final value in values ?? <pm.AuthKeyValue>[]) {
      if ((value.key ?? '').toLowerCase() == key.toLowerCase()) {
        return value.value;
      }
    }
    return null;
  }
}
