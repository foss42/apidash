import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String kDataBox = "apidash-data";
const String kKeyDataBoxIds = "ids";
const String kEnvironmentBox = "apidash-environment";
const String kKeyEnvironmentBoxIds = "env-ids";

const String kSettingsBox = "apidash-settings";

Future<void> openBoxes() async {
  await Hive.initFlutter();
  await Hive.openBox(kDataBox);
  await Hive.openBox(kSettingsBox);
  await Hive.openBox(kEnvironmentBox);
  await Hive.openBox(kKeyEnvironmentBoxIds);
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
  late final Box environmentBox;
  late final Box environmentIdsBox;

  HiveHandler() {
    dataBox = Hive.box(kDataBox);
    settingsBox = Hive.box(kSettingsBox);
    environmentBox = Hive.box(kEnvironmentBox);
    environmentIdsBox = Hive.box(kKeyEnvironmentBoxIds);
  }

  Map get settings => settingsBox.toMap();
  Future<void> saveSettings(Map data) => settingsBox.putAll(data);

  dynamic getIds() => dataBox.get(kKeyDataBoxIds);
  Future<void> setIds(List<String>? ids) => dataBox.put(kKeyDataBoxIds, ids);

  dynamic getRequestModel(String id) => dataBox.get(id);
  Future<void> setRequestModel(
          String id, Map<String, dynamic>? requestModelJson) =>
      dataBox.put(id, requestModelJson);

  List<String>? getEnvironmentIds() =>
      environmentIdsBox.get(kKeyEnvironmentBoxIds);
  Future<void> setEnvironmentIds(List<String>? ids) =>
      environmentIdsBox.put(kKeyEnvironmentBoxIds, ids);

  Future<void> setEnvironment(
          String id, Map<String, dynamic>? environmentJson) =>
      environmentBox.put(id, environmentJson);

  dynamic getEnvironment(String id) => environmentBox.get(id);
  Future<void> deleteEnvironment(String id) => environmentBox.delete(id);

  Future clear() async {
    await dataBox.clear();
    await environmentBox.clear();
    await environmentIdsBox.clear();
  }

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
