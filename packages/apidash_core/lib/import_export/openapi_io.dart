import 'package:openapi_spec/openapi_spec.dart';
import '../consts.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'package:seed/seed.dart';

class OpenApiIO {
  (String?, HttpRequestModel) oasOperationToHttpRequestModel(String url, Operation? operation, String methodName, OpenApi oas) {
    HTTPVerb method = HTTPVerb.values.byName((methodName));
    List<Parameter> parameters = operation?.parameters ?? <Parameter>[];
    List<NameValueModel> params = <NameValueModel>[];
    List<bool> isParamEnabledList = <bool>[];
    Map<String, Response>? res = operation?.responses ?? oas.components?.responses;
    List<bool> isHeaderEnabledList = <bool>[];
    List<NameValueModel> headers = <NameValueModel>[];
    RequestBody? requestBody = operation?.requestBody;
    Map<String, MediaType>? content = requestBody?.content;
    ContentType bodyContentType = ContentType.json;
    List<FormDataModel> formData = <FormDataModel>[];
    String body = "";


    // parameters
    // FIX: https://github.com/tazatechnology/openapi_spec/issues/76
    for (var param in parameters) {
      var name = param.name ?? "";
      var value = param.example ?? "";
      var activeQuery = param.deprecated ?? true;
      params.add(NameValueModel(name: name, value: value));
      isParamEnabledList.add(activeQuery);
    }

    // headers
    // FIX: https://github.com/tazatechnology/openapi_spec/issues/76
    res?.map((status, response) {
      return MapEntry(
        response.headers?.map((headerName, headerValue) {
          isHeaderEnabledList.add(headerValue != null ? true : false);
          headers.add(NameValueModel(name: headerName, value: headerValue));
          return const MapEntry(null, null);
        }),
        null
      );
    });


    // RequestBody TODO:
    content?.map((contentTypeStr, mediaType) {
      if (mediaType.schema?.ref != null) {
        var schemaas = oas.components?.schemas;
        var referencedSchemaDefinition = schemaas?[mediaType.schema?.ref];
        var properties = referencedSchemaDefinition?.toJson()['properties'];
        var bodyContent = properties.map((field, inputDetails) {
          // bodyContentType = getContentTypeFromContentTypeStr(contentTypeStr) ?? kDefaultContentType;
          // FIX: https://github.com/foss42/apidash/issues/771
          // TODO: reqBody content defines references to json && xml && formdata; suggestion - implement a bodyContentGenerator(); 
          // Note: body could be a NameValueModel so json && xml && formdata can be shown on APIDASH
          bodyContentType = kDefaultContentType;
          return MapEntry(field, inputDetails['example']);
        });
        body = bodyContent.toString();
      } else if (mediaType.examples != null) {
        mediaType.examples?.map((str, value) {
          body = value.value.toString();
          bodyContentType = getContentTypeFromContentTypeStr(contentTypeStr) ?? kDefaultContentType;
          // TODO: more than one example in openapi spec
          return const MapEntry(null, null);
        });
      } else {
        body = "";
      }

      // FIX: 
      if (bodyContentType == ContentType.formdata) {
        var name = mediaType.schema?.title ?? "";
        FormDataType formDataType;
        try {
          formDataType = FormDataType.values.byName(mediaType.schema?.runtimeType.toString() ?? "");
        } catch (e) {
          formDataType = FormDataType.text;
        }
        var value = switch (formDataType) {
          FormDataType.text => mediaType.schema.toString() ?? "",
          FormDataType.file => mediaType.schema.toString() ?? ""
        };
        formData.add(FormDataModel(
          name: name,
          value: value,
          type: formDataType
        ));
      }
      return const MapEntry(null, null);
    });

    return (operation?.id, HttpRequestModel(
      method: method,
      url: url,
      params: params,
      isParamEnabledList: isParamEnabledList,
      isHeaderEnabledList: isHeaderEnabledList,
      headers: headers,
      body: body,
      bodyContentType: bodyContentType,
      formData: formData
    ));
  }

  List<(String?, HttpRequestModel)>? getHttpRequestModelList(String content) {
    content = content.trim();
    try {

      const format = OpenApiFormat.yaml;
      final oas = OpenApi.fromString(source: content, format: format);
      final oasPaths = oas.paths ?? oas.components?.pathItems;
      List<(String?, HttpRequestModel)> httpRequestModelList = [];

      // Note: Schemas could be defined directly in the reqbody or in the components or maybe both
      // when schema is defined only in the components a reference to the scheme present in the components is provided
      oasPaths?.map((url, pathItem) { 
        if (pathItem.get != null) {
          httpRequestModelList.add(oasOperationToHttpRequestModel(url, pathItem.get, "get", oas));
        }
        if (pathItem.post != null) {
          httpRequestModelList.add(oasOperationToHttpRequestModel(url, pathItem.post, "post", oas));
        }
        if (pathItem.put != null) {
          httpRequestModelList.add(oasOperationToHttpRequestModel(url, pathItem.put, "put", oas));
        }
        if (pathItem.delete != null) {
          httpRequestModelList.add(oasOperationToHttpRequestModel(url, pathItem.delete, "delete", oas));
        }       
        if (pathItem.patch != null) {
          httpRequestModelList.add(oasOperationToHttpRequestModel(url, pathItem.patch, "patch", oas));
        }
        if (pathItem.head != null) {
          httpRequestModelList.add(oasOperationToHttpRequestModel(url, pathItem.head, "head", oas));
        }
        return const MapEntry(null, null);
      });
      return httpRequestModelList;
    } catch (e) {
        print("$e");
      return null;
    }
  }
}
