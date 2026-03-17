import 'package:genai/genai.dart';
import 'package:postman/postman.dart' as pm;

class PostmanIO {
  List<(String?, HttpRequestModel)>? getHttpRequestModelList(String content) {
    content = content.trim();
    try {
      final pc = pm.postmanCollectionFromJsonStr(content);
      final requests = pm.getRequestsFromPostmanCollection(pc);

      final collectionVariables = _buildVariableMap(pc.variable);
      final collectionAuth = pc.auth;

      return requests
          .map(
            (req) => (
              req.$1,
              postmanRequestToHttpRequestModel(
                req.$2,
                collectionVariables: collectionVariables,
                collectionAuth: collectionAuth,
              ),
            ),
          )
          .toList();
    } catch (e) {
      return null;
    }
  }

  HttpRequestModel postmanRequestToHttpRequestModel(
    pm.Request request, {
    Map<String, String> collectionVariables = const {},
    pm.Auth? collectionAuth,
  }) {
    HTTPVerb method;

    try {
      method = HTTPVerb.values.byName((request.method ?? '').toLowerCase());
    } catch (e) {
      method = kDefaultHttpMethod;
    }

    final rawUrl =
        _resolveVariables(request.url?.raw ?? '', collectionVariables);
    final url = stripUrlParams(rawUrl);
    final headers = <NameValueModel>[];
    final isHeaderEnabledList = <bool>[];

    final params = <NameValueModel>[];
    final isParamEnabledList = <bool>[];

    for (final header in request.header ?? <pm.Header>[]) {
      final name = _resolveVariables(header.key ?? '', collectionVariables);
      final value = _resolveVariables(header.value ?? '', collectionVariables);
      final activeHeader = header.disabled ?? false;
      headers.add(NameValueModel(name: name, value: value));
      isHeaderEnabledList.add(!activeHeader);
    }

    for (final query in request.url?.query ?? <pm.Query>[]) {
      final name = _resolveVariables(query.key ?? '', collectionVariables);
      final value = _resolveVariables(query.value ?? '', collectionVariables);
      final activeQuery = query.disabled ?? false;
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
              .byName(request.body?.options?.raw?.language ?? '');
        } catch (e) {
          bodyContentType = kDefaultContentType;
        }
        body = _resolveVariables(request.body?.raw ?? '', collectionVariables);
      }

      if (request.body?.mode == 'formdata') {
        bodyContentType = ContentType.formdata;
        formData = [];
        for (final fd in request.body?.formdata ?? <pm.Formdatum>[]) {
          if (fd.disabled ?? false) {
            continue;
          }

          final name = _resolveVariables(fd.key ?? '', collectionVariables);
          FormDataType formDataType;
          try {
            formDataType = FormDataType.values.byName(fd.type ?? '');
          } catch (e) {
            formDataType = FormDataType.text;
          }

          final value = switch (formDataType) {
            FormDataType.text =>
              _resolveVariables(fd.value ?? '', collectionVariables),
            FormDataType.file =>
              _resolveVariables(fd.src ?? '', collectionVariables),
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
        for (final field in request.body?.urlencoded ?? <pm.Urlencoded>[]) {
          if (field.disabled ?? false) {
            continue;
          }

          formData.add(
            FormDataModel(
              name: _resolveVariables(field.key ?? '', collectionVariables),
              value:
                  _resolveVariables(field.value ?? '', collectionVariables),
              type: FormDataType.text,
            ),
          );
        }
      }
    }

    final authModel = _postmanAuthToAuthModel(
          request.auth ?? collectionAuth,
          collectionVariables,
        ) ??
        const AuthModel(type: APIAuthType.none);

    return HttpRequestModel(
      method: method,
      url: url,
      headers: headers,
      params: params,
      authModel: authModel,
      isHeaderEnabledList: isHeaderEnabledList,
      isParamEnabledList: isParamEnabledList,
      body: body,
      bodyContentType: bodyContentType,
      formData: formData,
    );
  }

  Map<String, String> _buildVariableMap(List<pm.Variable>? variables) {
    final map = <String, String>{};
    for (final variable in variables ?? <pm.Variable>[]) {
      if (variable.disabled ?? false) {
        continue;
      }
      final key = (variable.key ?? '').trim();
      final value = variable.value;
      if (key.isEmpty || value == null) {
        continue;
      }
      map[key] = value.toString();
    }
    return map;
  }

  String _resolveVariables(String input, Map<String, String> variables) {
    final regex = RegExp(r'{{\s*([^}]+)\s*}}');
    return input.replaceAllMapped(regex, (match) {
      final key = (match.group(1) ?? '').trim();
      return variables[key] ?? match.group(0)!;
    });
  }

  AuthModel? _postmanAuthToAuthModel(
    pm.Auth? auth,
    Map<String, String> variables,
  ) {
    if (auth == null) {
      return null;
    }

    final type = (auth.type ?? '').toLowerCase();

    if (type == 'bearer') {
      final token = _resolveVariables(
        _getAuthValue(auth.bearer, 'token') ?? '',
        variables,
      );
      return token.isEmpty
          ? const AuthModel(type: APIAuthType.none)
          : AuthModel(
              type: APIAuthType.bearer,
              bearer: AuthBearerModel(token: token),
            );
    }

    if (type == 'basic') {
      final username = _resolveVariables(
        _getAuthValue(auth.basic, 'username') ?? '',
        variables,
      );
      final password = _resolveVariables(
        _getAuthValue(auth.basic, 'password') ?? '',
        variables,
      );
      if (username.isEmpty && password.isEmpty) {
        return const AuthModel(type: APIAuthType.none);
      }
      return AuthModel(
        type: APIAuthType.basic,
        basic: AuthBasicAuthModel(
          username: username,
          password: password,
        ),
      );
    }

    if (type == 'apikey') {
      final keyValue = _resolveVariables(
        _getAuthValue(auth.apikey, 'value') ?? '',
        variables,
      );
      final name = _resolveVariables(
        _getAuthValue(auth.apikey, 'key') ?? 'x-api-key',
        variables,
      );
      final where = (_getAuthValue(auth.apikey, 'in') ?? 'header').toLowerCase();
      final location = where == 'query' ? 'query' : 'header';

      if (keyValue.isEmpty) {
        return const AuthModel(type: APIAuthType.none);
      }

      return AuthModel(
        type: APIAuthType.apiKey,
        apikey: AuthApiKeyModel(
          key: keyValue,
          name: name,
          location: location,
        ),
      );
    }

    if (type == 'digest') {
      return AuthModel(
        type: APIAuthType.digest,
        digest: AuthDigestModel(
          username: _resolveVariables(
            _getAuthValue(auth.digest, 'username') ?? '',
            variables,
          ),
          password: _resolveVariables(
            _getAuthValue(auth.digest, 'password') ?? '',
            variables,
          ),
          realm: _resolveVariables(
            _getAuthValue(auth.digest, 'realm') ?? '',
            variables,
          ),
          nonce: _resolveVariables(
            _getAuthValue(auth.digest, 'nonce') ?? '',
            variables,
          ),
          algorithm: _resolveVariables(
            _getAuthValue(auth.digest, 'algorithm') ?? 'MD5',
            variables,
          ),
          qop: _resolveVariables(
            _getAuthValue(auth.digest, 'qop') ?? 'auth',
            variables,
          ),
          opaque: _resolveVariables(
            _getAuthValue(auth.digest, 'opaque') ?? '',
            variables,
          ),
        ),
      );
    }

    return const AuthModel(type: APIAuthType.none);
  }

  String? _getAuthValue(List<pm.AuthKeyValue>? entries, String key) {
    for (final entry in entries ?? <pm.AuthKeyValue>[]) {
      if (entry.disabled ?? false) {
        continue;
      }
      if ((entry.key ?? '').toLowerCase() == key.toLowerCase()) {
        return entry.value;
      }
    }
    return null;
  }
}
