import 'package:hive_flutter/hive_flutter.dart';

// constants
const String kDataBox = "data";

// sequence of ids
const String kDataBoxIds = "ids";

// dark theme boolean
const String kDataBoxTheme = "theme";

Future<void> openBoxes() async {
  await Hive.initFlutter();
  await Hive.openBox(kDataBox);
}

class HiveHandler {
  late final Box dataBox;

  HiveHandler() {
    dataBox = Hive.box(kDataBox);
  }

  dynamic getTheme() => dataBox.get(kDataBoxTheme);
  Future<void> setTheme(Map<String, dynamic>? theme) =>
      dataBox.put(kDataBoxTheme, theme);

  dynamic getIds() => dataBox.get(kDataBoxIds);
  Future<void> setIds(List<String>? ids) => dataBox.put(kDataBoxIds, ids);

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
        if (key != kDataBoxIds && !ids.contains(key)) {
          await dataBox.delete(key);
        }
      }
    }
  }
}
