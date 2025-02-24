import 'package:insomnia_collection/insomnia_collection.dart';
import 'package:seed/seed.dart';
import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class InsomniaIO {
  List<(String?, HttpRequestModel)>? getHttpRequestModelList(String content) {
    content = content.trim();
    try {
      final ic = insomniaCollectionFromJsonStr(content);
      final requests = getRequestsFromInsomniaCollection(ic);

      return requests
          .map((req) => (req.$1, insomniaResourceToHttpRequestModel(req.$2)))
          .toList();
    } catch (e) {
      return null;
    }
  }

  HttpRequestModel insomniaResourceToHttpRequestModel(Resource request) {
    HTTPVerb method;
    try {
      method = HTTPVerb.values.byName((request.method ?? "").toLowerCase());
    } catch (e) {
      method = kDefaultHttpMethod;
    }
    String url = stripUrlParams(request.url ?? "");
    List<NameValueModel> headers = [];
    List<bool> isHeaderEnabledList = [];

    List<NameValueModel> params = [];
    List<bool> isParamEnabledList = [];

    for (var header in request.headers ?? <Header>[]) {
      var name = header.name ?? "";
      var value = header.value ?? "";
      var activeHeader = header.disabled ?? false;
      headers.add(NameValueModel(name: name, value: value));
      isHeaderEnabledList.add(!activeHeader);
    }

    for (var query in request.parameters ?? <Parameter>[]) {
      var name = query.name ?? "";
      var value = query.value;
      var activeQuery = query.disabled ?? false;
      params.add(NameValueModel(name: name, value: value));
      isParamEnabledList.add(!activeQuery);
    }

    ContentType bodyContentType =
        getContentTypeFromContentTypeStr(request.body?.mimeType) ??
            kDefaultContentType;

    String? body;
    List<FormDataModel>? formData;
    if (request.body != null && request.body?.mimeType != null) {
      if (bodyContentType == ContentType.formdata) {
        formData = [];
        for (var fd in request.body?.params ?? <Formdatum>[]) {
          var name = fd.name ?? "";
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
      } else {
        body = request.body?.text;
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
