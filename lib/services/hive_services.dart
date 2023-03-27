import 'package:hive_flutter/hive_flutter.dart';

// constants
const String kDataBox = "data";

// sequence of ids
const String kDataBoxIds = "ids";

Future<void> openBoxes() async {
  await Hive.initFlutter();
  await Hive.openBox(kDataBox);
}

class HiveHandler {
  late final Box dataBox;

  HiveHandler() {
    dataBox = Hive.box(kDataBox);
  }

  List<String>? getIds() => dataBox.get(kDataBoxIds) as List<String>?;
  Future<void> setIds(List<String>? ids) => dataBox.put(kDataBoxIds, ids);

  Map<String, dynamic>? getRequestModel(String id) =>
      dataBox.get(id) as Map<String, dynamic>?;
  Future<void> setRequestModel(
          String id, Map<String, dynamic>? requestModelJson) =>
      dataBox.put(id, requestModelJson);

  Future<int> clear() => dataBox.clear();
}
