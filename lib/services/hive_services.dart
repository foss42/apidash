import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

const String kDataBox = "apidash-data";
const String kKeyDataBoxIds = "ids";

const String kSettingsBox = "apidash-settings";

Future<void> openBoxes() async {
  final supportDir = await getLibraryDirectory();
  await Hive.initFlutter(supportDir.path);
  await Hive.openBox(kDataBox);
  await Hive.openBox(kSettingsBox);
}

(Size?, Offset?) getInitialSize() {
  Size? sz;
  Offset? off;
  var settingsBox = Hive.box(kSettingsBox);
  double? w = settingsBox.get("width") as double?;
  double? h = settingsBox.get("height") as double?;
  if (w != null && h != null) {
    sz = Size(w, h);
  }
  double? dx = settingsBox.get("dx") as double?;
  double? dy = settingsBox.get("dy") as double?;
  if (dx != null && dy != null) {
    off = Offset(dx, dy);
  }
  return (sz, off);
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
