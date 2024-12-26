import 'package:postman/postman.dart' as pm;
import 'package:seed/seed.dart';
import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class PostmanIO {
  List<(String?, HttpRequestModel)>? getHttpRequestModelList(String content) {
    content = content.trim();
    try {
      final pc = pm.postmanCollectionFromJsonStr(content);
      final requests = pm.getRequestsFromPostmanCollection(pc);
      return requests
          .map((req) => (req.$1, postmanRequestToHttpRequestModel(req.$2)))
          .toList();
    } catch (e) {
      return null;
    }
  }

  HttpRequestModel postmanRequestToHttpRequestModel(pm.Request request) {
    HTTPVerb method;

    try {
      method = HTTPVerb.values.byName((request.method ?? "").toLowerCase());
    } catch (e) {
      method = kDefaultHttpMethod;
    }
    String url = stripUrlParams(request.url?.raw ?? "");
    List<NameValueModel> headers = [];
    List<bool> isHeaderEnabledList = [];

    List<NameValueModel> params = [];
    List<bool> isParamEnabledList = [];

    for (var header in request.header ?? <pm.Header>[]) {
      var name = header.key ?? "";
      var value = header.value;
      var activeHeader = header.disabled ?? false;
      headers.add(NameValueModel(name: name, value: value));
      isHeaderEnabledList.add(!activeHeader);
    }

    for (var query in request.url?.query ?? <pm.Query>[]) {
      var name = query.key ?? "";
      var value = query.value;
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
        body = request.body?.raw;
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
            FormDataType.text => fd.value ?? "",
            FormDataType.file => fd.src ?? ""
          };
          formData.add(FormDataModel(
            name: name,
            value: value,
            type: formDataType,
          ));
        }
      }
    }

    return HttpRequestModel(
      method: method,
      url: url,
      headers: headers,
      params: params,
      isHeaderEnabledList: isHeaderEnabledList,
      isParamEnabledList: isParamEnabledList,
      body: body,
      bodyContentType: bodyContentType,
      formData: formData,
    );
  }
}
