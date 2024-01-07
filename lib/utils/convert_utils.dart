import 'dart:typed_data';
import 'dart:convert';
import '../models/models.dart';
import '../consts.dart';
import 'package:http/http.dart' as http;

String humanizeDuration(Duration? duration) {
  if (duration == null) {
    return "";
  }
  if (duration.inMinutes >= 1) {
    var min = duration.inMinutes;
    var secs = duration.inSeconds.remainder(60) * 100 ~/ 60;
    var secondsPadding = secs < 10 ? "0" : "";
    return "$min.$secondsPadding$secs m";
  }
  if (duration.inSeconds >= 1) {
    var secs = duration.inSeconds;
    var mili = duration.inMilliseconds.remainder(1000) ~/ 10;
    var milisecondsPadding = mili < 10 ? "0" : "";
    return "$secs.$milisecondsPadding$mili s";
  } else {
    var mili = duration.inMilliseconds;
    return "$mili ms";
  }
}

String audioPosition(Duration? duration) {
  if (duration == null) return "";
  var min = duration.inMinutes;
  var secs = duration.inSeconds.remainder(60);
  var secondsPadding = secs < 10 ? "0" : "";
  return "$min:$secondsPadding$secs";
}

String capitalizeFirstLetter(String? text) {
  if (text == null || text == "") {
    return "";
  } else if (text.length == 1) {
    return text.toUpperCase();
  } else {
    var first = text[0];
    var rest = text.substring(1);
    return first.toUpperCase() + rest;
  }
}

String formatHeaderCase(String text) {
  var sp = text.split("-");
  sp = sp.map((e) => capitalizeFirstLetter(e)).toList();
  return sp.join("-");
}

String padMultilineString(String text, int padding,
    {bool firstLinePadded = false}) {
  var lines = kSplitter.convert(text);
  int start = firstLinePadded ? 0 : 1;
  for (start; start < lines.length; start++) {
    lines[start] = ' ' * padding + lines[start];
  }
  return lines.join("\n");
}

Map<String, String>? rowsToMap(List<NameValueModel>? kvRows,
    {bool isHeader = false}) {
  if (kvRows == null) {
    return null;
  }
  Map<String, String> finalMap = {};
  for (var row in kvRows) {
    if (row.name.trim() != "") {
      String key = row.name;
      if (isHeader) {
        key = key.toLowerCase();
      }
      finalMap[key] = row.value.toString();
    }
  }
  return finalMap;
}

List<NameValueModel>? mapToRows(Map<String, String>? kvMap) {
  if (kvMap == null) {
    return null;
  }
  List<NameValueModel> finalRows = [];
  for (var k in kvMap.keys) {
    finalRows.add(NameValueModel(name: k, value: kvMap[k]));
  }
  return finalRows;
}

List<Map<String, dynamic>>? rowsToFormDataMapList(
  List<FormDataModel>? kvRows,
) {
  if (kvRows == null) {
    return null;
  }
  List<Map<String, dynamic>> finalMap = kvRows
      .map((FormDataModel formData) => {
            "name": formData.name,
            "value": formData.value,
            "type": formData.type.name,
          })
      .toList();
  return finalMap;
}

List<FormDataModel>? mapListToFormDataModelRows(List<Map>? kvMap) {
  if (kvMap == null) {
    return null;
  }
  List<FormDataModel> finalRows = kvMap.map(
    (formData) {
      return FormDataModel(
        name: formData["name"],
        value: formData["value"],
        type: getFormDataType(formData["type"]),
      );
    },
  ).toList();
  return finalRows;
}

FormDataType getFormDataType(String? type) {
  return FormDataType.values.firstWhere((element) => element.name == type,
      orElse: () => FormDataType.text);
}

Uint8List? stringToBytes(String? text) {
  if (text == null) {
    return null;
  } else {
    var l = utf8.encode(text);
    var bytes = Uint8List.fromList(l);
    return bytes;
  }
}

Uint8List jsonMapToBytes(Map<String, dynamic>? map) {
  if (map == null) {
    return Uint8List.fromList([]);
  } else {
    String text = kEncoder.convert(map);
    var l = utf8.encode(text);
    var bytes = Uint8List.fromList(l);
    return bytes;
  }
}

Future<http.Response> convertStreamedResponse(
  http.StreamedResponse streamedResponse,
) async {
  Uint8List bodyBytes = await streamedResponse.stream.toBytes();

  http.Response response = http.Response.bytes(
    bodyBytes,
    streamedResponse.statusCode,
    headers: streamedResponse.headers,
    persistentConnection: streamedResponse.persistentConnection,
    reasonPhrase: streamedResponse.reasonPhrase,
    request: streamedResponse.request,
  );

  return response;
}

List<NameValueModel>? getEnabledRows(
    List<NameValueModel>? rows, List<bool>? isRowEnabledList) {
  if (rows == null || isRowEnabledList == null) {
    return rows;
  }
  List<NameValueModel> finalRows =
      rows.where((element) => isRowEnabledList[rows.indexOf(element)]).toList();
  return finalRows == [] ? null : finalRows;
}
