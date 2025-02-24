import 'package:flutter/material.dart';
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
      debugPrint("$e");
      return null;
    }
  }

  HttpRequestModel insomniaResourceToHttpRequestModel(Resource resource) {
    HTTPVerb method;
    try {
      method = HTTPVerb.values.byName((resource.method ?? "").toLowerCase());
    } catch (e) {
      method = kDefaultHttpMethod;
    }
    String url = stripUrlParams(resource.url ?? "");
    List<NameValueModel> headers = [];
    List<bool> isHeaderEnabledList = [];

    List<NameValueModel> params = [];
    List<bool> isParamEnabledList = [];

    for (var header in resource.headers ?? <Header>[]) {
      var name = header.name ?? "";
      var value = header.value ?? "";
      var activeHeader = header.disabled ?? false;
      headers.add(NameValueModel(name: name, value: value));
      isHeaderEnabledList.add(!activeHeader);
    }

    for (var query in resource.parameters ?? <Parameter>[]) {
      var name = query.name ?? "";
      var value = query.value;
      var activeQuery = query.disabled ?? false;
      params.add(NameValueModel(name: name, value: value));
      isParamEnabledList.add(!activeQuery);
    }

    ContentType bodyContentType =
        getContentTypeFromContentTypeStr(resource.body?.mimeType) ??
            kDefaultContentType;

    String? body;
    List<FormDataModel>? formData;
    if (resource.body != null && resource.body?.mimeType != null) {
      if (bodyContentType == ContentType.formdata) {
        formData = [];
        for (var fd in resource.body?.params ?? <Formdatum>[]) {
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
        body = resource.body?.text;
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

  EnvironmentModel insomniaResourceToEnvironmentModel(Resource resource) {
    List<EnvironmentVariableModel> variables = [];
    for (var envvar in resource.kvPairData!) {
      variables.add(EnvironmentVariableModel(
        key: envvar.name ?? "",
        value: envvar.value ?? "",
        enabled: envvar.enabled ?? true,
        type: envvar.type == "secret"
            ? EnvironmentVariableType.secret
            : EnvironmentVariableType.variable,
      ));
    }
    return EnvironmentModel(
      id: resource.id!,
      name: resource.name ?? "",
      values: variables,
    );
  }
}
