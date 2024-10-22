// http://www.softwareishard.com/blog/har-12-spec/
// https://github.com/ahmadnassri/har-spec/blob/master/versions/1.2.md

import 'dart:convert';
import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart' show getNewUuid, getFilenameFromPath;
import 'package:apidash/models/models.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<Map<String, dynamic>> collectionToHAR(
    List<RequestModel>? collection) async {
  Map<String, dynamic> harJson = {
    "log": {
      "creator": {
        "comment": "For support, check out API Dash repo - $kGitUrl",
        "version": (await PackageInfo.fromPlatform()).version,
        "name": "API Dash"
      },
      "entries": <Map<String, dynamic>>[],
      "comment": "",
      "browser": {
        "version": (await PackageInfo.fromPlatform()).version,
        "comment": "",
        "name": "API Dash"
      },
      "version": "1.2"
    }
  };

  if (collection != null) {
    for (final req in collection) {
      harJson["log"]["entries"].add(entryToHAR(req));
    }
  }
  return harJson;
}

Map<String, dynamic> entryToHAR(RequestModel requestModel) {
  Map<String, dynamic> entryJson = {
    "startedDateTime": DateTime.now().toUtc().toIso8601String(),
    "comment":
        "${requestModel.name.isNotEmpty ? '${requestModel.name} | ' : ''}id:${requestModel.id}",
    "serverIPAddress": "",
    "time": 0,
    "timings": {
      "connect": -1,
      "comment": "",
      "blocked": -1,
      "dns": -1,
      "receive": 0,
      "send": 0,
      "wait": 0,
      "ssl": -1
    },
    "response": {
      "status": 200,
      "statusText": "OK",
      "httpVersion": "HTTP/1.1",
      "cookies": [],
      "headers": [],
      "content": {"size": 0, "mimeType": "", "comment": "", "text": ""},
      "redirectURL": "",
      "headersSize": 0,
      "bodySize": 0,
      "comment": ""
    },
    "request": requestModel.httpRequestModel != null
        ? requestModelToHARJsonRequest(
            requestModel.httpRequestModel!,
            exportMode: true,
          )
        : {},
    "cache": {}
  };
  return entryJson;
}

Map<String, dynamic> requestModelToHARJsonRequest(
  HttpRequestModel? requestModel, {
  defaultUriScheme = kDefaultUriScheme,
  bool exportMode = false,
  bool useEnabled = false,
  String? boundary,
}) {
  Map<String, dynamic> json = {};
  bool hasBody = false;

  if (requestModel == null) {
    return json;
  }

  var rec = getValidRequestUri(
    requestModel.url,
    useEnabled ? requestModel.enabledParams : requestModel.params,
    defaultUriScheme: defaultUriScheme,
  );

  Uri? uri = rec.$1;
  var u = "";
  if (uri != null) {
    u = uri.toString();
    if (u[u.length - 1] == "?") {
      u = u.substring(0, u.length - 1);
    }

    json["method"] = requestModel.method.name.toUpperCase();
    json["url"] = u;
    json["httpVersion"] = "HTTP/1.1";
    json["queryString"] = [];
    json["headers"] = [];

    var params = uri.queryParameters;
    if (params.isNotEmpty) {
      for (final k in params.keys) {
        var m = {"name": k, "value": params[k]};
        if (exportMode) {
          m["comment"] = "";
        }
        json["queryString"].add(m);
      }
    }

    if (requestModel.hasJsonData || requestModel.hasTextData) {
      hasBody = true;
      json["postData"] = {};
      json["postData"]["mimeType"] = requestModel.bodyContentType.header;
      json["postData"]["text"] = requestModel.body;
      if (exportMode) {
        json["postData"]["comment"] = "";
      }
    }

    if (requestModel.hasFormData) {
      boundary = boundary ?? getNewUuid();
      hasBody = true;
      json["postData"] = {};
      json["postData"]["mimeType"] =
          "${requestModel.bodyContentType.header}; boundary=$boundary";
      json["postData"]["params"] = [];
      for (var item in requestModel.formDataList) {
        Map<String, String> d = exportMode ? {"comment": ""} : {};
        if (item.type == FormDataType.text) {
          d["name"] = item.name;
          d["value"] = item.value;
        }
        if (item.type == FormDataType.file) {
          d["name"] = item.name;
          d["fileName"] = getFilenameFromPath(item.value);
        }
        json["postData"]["params"].add(d);
      }
      if (exportMode) {
        json["postData"]["comment"] = "";
      }
    }

    var headersList =
        useEnabled ? requestModel.enabledHeaders : requestModel.headers;
    if (headersList != null || hasBody) {
      var headers =
          useEnabled ? requestModel.enabledHeadersMap : requestModel.headersMap;
      if (headers.isNotEmpty || hasBody) {
        if (hasBody && !requestModel.hasContentTypeHeader) {
          var m = {
            "name": kHeaderContentType,
            "value": json["postData"]["mimeType"]
          };
          if (exportMode) {
            m["comment"] = "";
          }
          json["headers"].add(m);
        }
        for (final k in headers.keys) {
          var m = {"name": k, "value": headers[k]};
          if (exportMode) {
            m["comment"] = "";
          }
          json["headers"].add(m);
        }
      }
    }
    if (exportMode) {
      json["comment"] = "";
      json["cookies"] = [];
      json["headersSize"] = -1;
      json["bodySize"] =
          hasBody ? utf8.encode(json["postData"]["text"] ?? "").length : 0;
    }
  }
  return json;
}
