import 'dart:convert';
import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/utils/file_utils.dart' show getNewUuid, getFilenameFromPath;

/// Converts a list of [RequestModel] from the apidash collection
/// into an Insomnia v4 export format JSON map.
Map<String, dynamic> collectionToInsomnia(
  List<RequestModel>? collection, {
  String collectionName = 'API Dash Collection',
}) {
  final now = DateTime.now().toUtc();
  final timestamp = now.millisecondsSinceEpoch;
  final exportDate = now.toIso8601String();

  final workspaceId = 'wrk_${getNewUuid().replaceAll('-', '').substring(0, 24)}';
  final folderId = 'fld_${getNewUuid().replaceAll('-', '').substring(0, 24)}';

  final List<Map<String, dynamic>> resources = [];

  // Workspace (root collection)
  resources.add({
    '_id': workspaceId,
    'modified': timestamp,
    'created': timestamp,
    'name': collectionName,
    'description': '',
    'scope': 'collection',
    '_type': 'workspace',
  });

  // Request group (folder for all requests)
  resources.add({
    '_id': folderId,
    'parentId': workspaceId,
    'modified': timestamp,
    'created': timestamp,
    'name': collectionName,
    'description': '',
    'authentication': <String, dynamic>{},
    'metaSortKey': -timestamp,
    'isPrivate': false,
    'afterResponseScript': '',
    'environment': <String, dynamic>{},
    '_type': 'request_group',
  });

  if (collection != null) {
    var metaSortKey = -timestamp;
    for (final req in collection) {
      if (req.httpRequestModel == null) continue;

      final requestResource = _requestModelToInsomniaResource(
        req,
        folderId,
        metaSortKey,
      );
      resources.add(requestResource);
      metaSortKey++;
    }
  }

  return {
    '_type': 'export',
    '__export_format': 4,
    '__export_date': exportDate,
    '__export_source': 'apidash',
    'resources': resources,
  };
}

Map<String, dynamic> _requestModelToInsomniaResource(
  RequestModel requestModel,
  String parentId,
  num metaSortKey,
) {
  final httpReq = requestModel.httpRequestModel!;
  final now = DateTime.now().toUtc();
  final timestamp = now.millisecondsSinceEpoch;
  final requestId = 'req_${getNewUuid().replaceAll('-', '').substring(0, 24)}';

  final itemName = requestModel.name.isNotEmpty
      ? requestModel.name
      : httpReq.url.isNotEmpty
          ? httpReq.url
          : 'Untitled Request';

  // Build URL with query params
  final rawUrl = httpReq.url;
  String urlWithParams = rawUrl;
  final params = httpReq.params;
  final isParamEnabledList = httpReq.isParamEnabledList;
  if (params != null && params.isNotEmpty) {
    final enabledParams = <NameValueModel>[];
    for (var i = 0; i < params.length; i++) {
      if (params[i].name.isEmpty) continue;
      final enabled = isParamEnabledList == null ||
          i >= isParamEnabledList.length ||
          isParamEnabledList[i];
      if (enabled) {
        enabledParams.add(params[i]);
      }
    }
    if (enabledParams.isNotEmpty) {
      final queryString = enabledParams
          .map((p) =>
              '${Uri.encodeQueryComponent(p.name)}=${Uri.encodeQueryComponent(p.value)}')
          .join('&');
      urlWithParams = rawUrl.contains('?')
          ? '$rawUrl&$queryString'
          : '$rawUrl?$queryString';
    }
  }

  // Parameters (query params)
  final List<Map<String, dynamic>> parameters = [];
  if (params != null) {
    for (var i = 0; i < params.length; i++) {
      if (params[i].name.isEmpty) continue;
      final disabled = isParamEnabledList != null &&
          i < isParamEnabledList.length &&
          !isParamEnabledList[i];
      parameters.add({
        'id': 'pair_${getNewUuid().replaceAll('-', '').substring(0, 24)}',
        'name': params[i].name,
        'value': params[i].value,
        'description': '',
        'disabled': disabled,
      });
    }
  }

  // Headers
  final List<Map<String, dynamic>> headers = [];
  final headersList = httpReq.headers;
  final isHeaderEnabledList = httpReq.isHeaderEnabledList;
  if (headersList != null) {
    for (var i = 0; i < headersList.length; i++) {
      if (headersList[i].name.isEmpty) continue;
      final disabled = isHeaderEnabledList != null &&
          i < isHeaderEnabledList.length &&
          !isHeaderEnabledList[i];
      headers.add({
        'name': headersList[i].name,
        'value': headersList[i].value,
        'disabled': disabled,
      });
    }
  }

  // Body
  Map<String, dynamic> body = {};
  if (httpReq.hasJsonData || httpReq.hasTextData) {
    body = {
      'mimeType': httpReq.bodyContentType.header,
      'text': httpReq.body ?? '',
    };
    if (!httpReq.hasContentTypeHeader && (httpReq.body ?? '').isNotEmpty) {
      headers.add({
        'name': 'Content-Type',
        'value': httpReq.bodyContentType.header,
        'disabled': false,
      });
    }
  } else if (httpReq.hasFormData) {
    final formParams = httpReq.formDataList
        .where((fd) => fd.name.isNotEmpty)
        .map((fd) {
          final map = <String, dynamic>{
            'name': fd.name,
            'type': fd.type.name,
          };
          if (fd.type == FormDataType.text) {
            map['value'] = fd.value;
          } else {
            map['fileName'] = getFilenameFromPath(fd.value);
            map['value'] = fd.value;
          }
          return map;
        })
        .toList();
    body = {
      'mimeType': 'multipart/form-data',
      'params': formParams,
    };
  }

  return {
    '_id': requestId,
    'parentId': parentId,
    'modified': timestamp,
    'created': timestamp,
    'url': urlWithParams,
    'name': itemName,
    'description': requestModel.description,
    'method': httpReq.method.name.toUpperCase(),
    'body': body,
    'preRequestScript': requestModel.preRequestScript ?? '',
    'parameters': parameters,
    'headers': headers,
    'authentication': <String, dynamic>{},
    'metaSortKey': metaSortKey,
    'isPrivate': false,
    'pathParameters': [],
    'settingStoreCookies': true,
    'settingSendCookies': true,
    'settingDisableRenderRequestBody': false,
    'settingEncodeUrl': true,
    'settingRebuildPath': true,
    'settingFollowRedirects': 'global',
    'afterResponseScript': requestModel.postRequestScript ?? '',
    '_type': 'request',
  };
}

/// Converts an Insomnia export JSON map to a formatted JSON string.
String insomniaCollectionToJsonString(Map<String, dynamic> collection) {
  return const JsonEncoder.withIndent('  ').convert(collection);
}
