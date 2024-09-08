import 'package:hive_flutter/hive_flutter.dart';

const String kDataBox = "apidash-data";
const String kKeyDataBoxIds = "ids";

const String kEnvironmentBox = "apidash-environments";
const String kKeyEnvironmentBoxIds = "environmentIds";

const String kHistoryMetaBox = "apidash-history-meta";
const String kHistoryBoxIds = "historyIds";
const String kHistoryLazyBox = "apidash-history-lazy";

Future<bool> openBoxes(
  bool isDesktop,
  String? workspaceFolderPath,
) async {
  try {
    if (isDesktop) {
      if (workspaceFolderPath != null) {
        Hive.init(workspaceFolderPath);
      } else {
        return false;
      }
    } else {
      await Hive.initFlutter();
    }

    await Hive.openBox(kDataBox);
    await Hive.openBox(kEnvironmentBox);
    await Hive.openBox(kHistoryMetaBox);
    await Hive.openLazyBox(kHistoryLazyBox);
    return true;
  } catch (e) {
    return false;
  }
}

final hiveHandler = HiveHandler();

class HiveHandler {
  late final Box dataBox;
  late final Box environmentBox;
  late final Box historyMetaBox;
  late final LazyBox historyLazyBox;

  HiveHandler() {
    dataBox = Hive.box(kDataBox);
    environmentBox = Hive.box(kEnvironmentBox);
    historyMetaBox = Hive.box(kHistoryMetaBox);
    historyLazyBox = Hive.lazyBox(kHistoryLazyBox);
  }

  dynamic getIds() => dataBox.get(kKeyDataBoxIds);
  Future<void> setIds(List<String>? ids) => dataBox.put(kKeyDataBoxIds, ids);

  dynamic getRequestModel(String id) => dataBox.get(id);
  Future<void> setRequestModel(
          String id, Map<String, dynamic>? requestModelJson) =>
      dataBox.put(id, requestModelJson);

  void delete(String key) => dataBox.delete(key);

  dynamic getEnvironmentIds() => environmentBox.get(kKeyEnvironmentBoxIds);
  Future<void> setEnvironmentIds(List<String>? ids) =>
      environmentBox.put(kKeyEnvironmentBoxIds, ids);

  dynamic getEnvironment(String id) => environmentBox.get(id);
  Future<void> setEnvironment(
          String id, Map<String, dynamic>? environmentJson) =>
      environmentBox.put(id, environmentJson);

  Future<void> deleteEnvironment(String id) => environmentBox.delete(id);

  dynamic getHistoryIds() => historyMetaBox.get(kHistoryBoxIds);
  Future<void> setHistoryIds(List<String>? ids) =>
      historyMetaBox.put(kHistoryBoxIds, ids);

  dynamic getHistoryMeta(String id) => historyMetaBox.get(id);
  Future<void> setHistoryMeta(
          String id, Map<String, dynamic>? historyMetaJson) =>
      historyMetaBox.put(id, historyMetaJson);

  Future<void> deleteHistoryMeta(String id) => historyMetaBox.delete(id);

  Future<dynamic> getHistoryRequest(String id) async =>
      await historyLazyBox.get(id);
  Future<void> setHistoryRequest(
          String id, Map<String, dynamic>? historyRequestJsoon) =>
      historyLazyBox.put(id, historyRequestJsoon);

  Future<void> deleteHistoryRequest(String id) => historyLazyBox.delete(id);

  Future clear() async {
    await dataBox.clear();
    await environmentBox.clear();
  }

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
    var environmentIds = getEnvironmentIds();
    if (environmentIds != null) {
      environmentIds = environmentIds as List;
      for (var key in environmentBox.keys.toList()) {
        if (key != kKeyEnvironmentBoxIds && !environmentIds.contains(key)) {
          await environmentBox.delete(key);
        }
      }
    }
  }
}
