import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';

class JsonUtils {
  static bool isValidJson(String? jsonString) {
    if (jsonString == null) {
      return false;
    }
    try {
      json.decode(jsonString);
      return true;
    } on FormatException catch (_) {
      return false;
    }
  }

  static String? getJsonParsingError(String? jsonString) {
    if (jsonString == null) {
      return null;
    }
    try {
      json.decode(jsonString);

      return null;
    } on FormatException catch (e) {
      return e.message;
    }
  }

  static String getPrettyPrintJson(String jsonString) {
    var jsonObject = json.decode(jsonString);
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String prettyString = encoder.convert(jsonObject);
    return prettyString;
  }

  static String getSortJsonString(String jsonString) {
    dynamic sort(dynamic value) {
      if (value is Map) {
        return SplayTreeMap<String, dynamic>.from(
          value.map((key, value) => MapEntry(key, sort(value))),
        );
      } else if (value is List) {
        return value.map(sort).toList();
      } else {
        return value;
      }
    }

    var jsonObject = json.decode(jsonString);
    var sortedMap = sort(jsonObject);
    String sortedJsonString = json.encode(sortedMap);
    return sortedJsonString;
  }

  static void formatTextFieldJson({
    required bool sortJson,
    required TextEditingController controller,
  }) {
    final oldText = controller.text;
    final oldSelection = controller.selection;

    controller.text =
        sortJson
            ? JsonUtils.getPrettyPrintJson(
              JsonUtils.getSortJsonString(controller.text),
            )
            : JsonUtils.getPrettyPrintJson(controller.text);

    final addedCharacters = controller.text.length - oldText.length;
    final newSelectionStart = oldSelection.start + addedCharacters;
    final newSelectionEnd = oldSelection.end + addedCharacters;

    controller.selection = TextSelection(
      baseOffset: newSelectionStart,
      extentOffset: newSelectionEnd,
    );
  }

  static validateJson({
    required String json,
    required Function(String?) onError,
  }) {
    if (json.isEmpty) return onError(null);

    if (JsonUtils.isValidJson(json)) {
      onError(null);
    } else {
      onError(JsonUtils.getJsonParsingError(json));
    }
  }
}
