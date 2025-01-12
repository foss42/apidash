import 'package:seed/seed.dart';
import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'package:insomnia_collection/insomnia_collection.dart' as ins;




class InsomniaIO {
  List<(String?, HttpRequestModel)>? getHttpRequestModelList(String content) {
    content = content.trim();
    try {
      final ic = ins.insomniaCollectionFromJsonStr(content);
      final requests = ins.getRequestsFromInsomniaCollection(ic);
      return requests
          .map((req) => (req.$1, insomniaRequestToHttpRequestModel(req.$2)))
          .toList();
    } catch (e) {
      return null;
    }
  }

  HttpRequestModel insomniaRequestToHttpRequestModel(ins.Resource request) {
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

    for (var header in request.headers ?? <ins.Header>[]) {
      var name = header.name ?? "";
      var value = header.value ?? "";
      var activeHeader = header.disabled ?? false;
      headers.add(NameValueModel(name: name, value: value));
      isHeaderEnabledList.add(!activeHeader);
    }

    for (var query in request.parameters ?? <ins.Parameter>[]) {
      var name = query.name ?? "";
      var value = query.value;
      var activeQuery = query.disabled ?? false;
      params.add(NameValueModel(name: name, value: value));
      isParamEnabledList.add(!activeQuery);
    }

    ContentType bodyContentType = kDefaultContentType;
    String? body;
    List<FormDataModel>? formData;
    if (request.body != null) {
      if (request.body?.mimeType != null) {
        try {
          bodyContentType = ContentType.values
              .byName(request.body?.mimeType ?? "");
        } catch (e) {
          bodyContentType = kDefaultContentType;
        }
        body = request.body?.text;
      }
      /// TODO: Handle formdata and text
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