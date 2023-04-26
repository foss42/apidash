import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String kDataBox = "data";
const String kKeyDataBoxIds = "ids";

const String kSettingsBox = "settings";

Future<void> openBoxes() async {
  await Hive.initFlutter();
  await Hive.openBox(kDataBox);
  await Hive.openBox(kSettingsBox);
}

Size? getInitialSize() {
  var settingsBox = Hive.box(kSettingsBox);
  double? w = settingsBox.get("width") as double?;
  double? h = settingsBox.get("height") as double?;
  if (w != null && h != null) {
    return Size(w, h);
  }
  return null;
}

final hiveHandler = HiveHandler();

class HiveHandler {
  late final Box dataBox;
  late final Box settingsBox;

  HiveHandler() {
    dataBox = Hive.box(kDataBox);
    settingsBox = Hive.box(kSettingsBox);
  }

  Map get settings => settingsBox.toMap();
  Future<void> saveSettings(Map data) => settingsBox.putAll(data);

  dynamic getIds() => dataBox.get(kKeyDataBoxIds);
  Future<void> setIds(List<String>? ids) => dataBox.put(kKeyDataBoxIds, ids);

  dynamic getRequestModel(String id) => dataBox.get(id);
  Future<void> setRequestModel(
          String id, Map<String, dynamic>? requestModelJson) =>
      dataBox.put(id, requestModelJson);

  Future<int> clear() => dataBox.clear();

  void delete(String key) => dataBox.delete(key);

  Future<void> removeUnused() async {
    var ids = getIds();
    if (ids != null) {
      ids = ids as List;
      for (var key in dataBox.keys.toList()) {
        if (key != kKeyDataBoxIds && !ids.contains(key)) {
          await dataBox.delete(key);
        }
      }
    }
  }
}
