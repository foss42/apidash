import 'package:better_networking/better_networking.dart';
import 'package:json5/json5.dart' as json5;

// FIX: Change return type to Map<String, List<String>> to support duplicate keys
Map<String, List<String>>? rowsToMap(
  List<NameValueModel>? kvRows, {
  bool isHeader = false,
}) {
  if (kvRows == null) {
    return null;
  }

  Map<String, List<String>> finalMap = {};

  for (var row in kvRows) {
    if (row.name.trim().isNotEmpty) {
      String key = row.name;
      if (isHeader) {
        key = key.toLowerCase();
      }

      // Initialize the list if the key doesn't exist
      if (!finalMap.containsKey(key)) {
        finalMap[key] = [];
      }

      // Add the value to the list instead of overwriting the key
      finalMap[key]!.add(row.value.toString());
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

List<Map<String, String>>? rowsToFormDataMapList(List<FormDataModel>? kvRows) {
  if (kvRows == null) {
    return null;
  }
  // Added cast to List<Map<String, String>> to ensure type safety
  return kvRows
      .where((formData) =>
          formData.name.trim().isNotEmpty || formData.value.trim().isNotEmpty)
      .map((formData) => {
            "name": formData.name,
            "value": formData.value,
            "type": formData.type.name,
          })
      .toList();
}

List<FormDataModel>? mapListToFormDataModelRows(List<dynamic>? kvMap) {
  if (kvMap == null) {
    return null;
  }
  return kvMap.map((formData) {
    return FormDataModel(
      name: formData["name"],
      value: formData["value"],
      type: getFormDataType(formData["type"]),
    );
  }).toList();
}

FormDataType getFormDataType(String? type) {
  return FormDataType.values.firstWhere(
    (element) => element.name == type,
    orElse: () => FormDataType.text,
  );
}

// FIX: Helper function for checking enabled rows
List<NameValueModel>? getEnabledRows(
  List<NameValueModel>? rows,
  List<bool>? isRowEnabledList,
) {
  if (rows == null || isRowEnabledList == null) {
    return rows;
  }

  List<NameValueModel> finalRows = [];
  for (int i = 0; i < rows.length; i++) {
    if (i < isRowEnabledList.length && isRowEnabledList[i]) {
      finalRows.add(rows[i]);
    }
  }

  return finalRows;
}

String? getRequestBody(APIType type, HttpRequestModel httpRequestModel) {
  return switch (type) {
    APIType.rest =>
      (httpRequestModel.hasJsonData || httpRequestModel.hasTextData)
          ? httpRequestModel.body
          : null,
    APIType.graphql => getGraphQLBody(httpRequestModel),
    APIType.ai => null, //TODO: TAKE A LOOK
  };
}

// TODO: Expose this function to remove JSON comments
String? removeJsonComments(String? json) {
  try {
    if (json == null) return null;
    var parsed = json5.json5Decode(json);
    return kJsonEncoder.convert(parsed);
  } catch (e) {
    return json;
  }
}
