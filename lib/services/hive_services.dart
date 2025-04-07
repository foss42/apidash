import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String kDataBox = "apidash-data";
const String kKeyDataBoxIds = "ids";

const String kApiSpecsBox = "apidash-api-specs";
const String kApiSpecsBoxIds = "apiSpecsIds";

const String kEnvironmentBox = "apidash-environments";
const String kKeyEnvironmentBoxIds = "environmentIds";

const String kHistoryMetaBox = "apidash-history-meta";
const String kHistoryBoxIds = "historyIds";
const String kHistoryLazyBox = "apidash-history-lazy";

Future<bool> initHiveBoxes(
  bool initializeUsingPath,
  String? workspaceFolderPath,
) async {
  try {
    if (initializeUsingPath) {
      if (workspaceFolderPath != null) {
        Hive.init(workspaceFolderPath);
      } else {
        return false;
      }
    } else {
      await Hive.initFlutter(workspaceFolderPath);
    }
    final openHiveBoxesStatus = await openHiveBoxes();
    await Hive.openBox(kApiSpecsBox);
    return openHiveBoxesStatus;
  } catch (e) {
    return false;
  }
}

Future<bool> openHiveBoxes() async {
  try {
    await Hive.openBox(kDataBox);
    await Hive.openBox(kEnvironmentBox);
    await Hive.openBox(kHistoryMetaBox);
    await Hive.openLazyBox(kHistoryLazyBox);
    await Hive.openBox(kApiSpecsBox);
    return true;
  } catch (e) {
    debugPrint("ERROR OPEN HIVE BOXES: $e");
    return false;
  }
}

Future<void> clearHiveBoxes() async {
  try {
    if (Hive.isBoxOpen(kDataBox)) {
      await Hive.box(kDataBox).clear();
    }
    if (Hive.isBoxOpen(kEnvironmentBox)) {
      await Hive.box(kEnvironmentBox).clear();
    }
    if (Hive.isBoxOpen(kHistoryMetaBox)) {
      await Hive.box(kHistoryMetaBox).clear();
    }
    if (Hive.isBoxOpen(kHistoryLazyBox)) {
      await Hive.lazyBox(kHistoryLazyBox).clear();
    }
    if (Hive.isBoxOpen(kApiSpecsBox)) {
      await Hive.box(kApiSpecsBox).clear();
    }
  } catch (e) {
    debugPrint("ERROR CLEAR HIVE BOXES: $e");
  }
}

Future<void> deleteHiveBoxes() async {
  try {
    if (Hive.isBoxOpen(kDataBox)) {
      await Hive.box(kDataBox).deleteFromDisk();
    }
    if (Hive.isBoxOpen(kEnvironmentBox)) {
      await Hive.box(kEnvironmentBox).deleteFromDisk();
    }
    if (Hive.isBoxOpen(kHistoryMetaBox)) {
      await Hive.box(kHistoryMetaBox).deleteFromDisk();
    }
    if (Hive.isBoxOpen(kHistoryLazyBox)) {
      await Hive.lazyBox(kHistoryLazyBox).deleteFromDisk();
    }
    if (Hive.isBoxOpen(kApiSpecsBox)) {
      await Hive.box(kApiSpecsBox).deleteFromDisk();
    }
    await Hive.close();
  } catch (e) {
    debugPrint("ERROR DELETE HIVE BOXES: $e");
  }
}

final hiveHandler = HiveHandler();

class HiveHandler {
  late final Box dataBox;
  late final Box environmentBox;
  late final Box historyMetaBox;
  late final LazyBox historyLazyBox;
  late final Box apiSpecsBox;
  HiveHandler() {
    debugPrint("Trying to open Hive boxes");
    dataBox = Hive.box(kDataBox);
    environmentBox = Hive.box(kEnvironmentBox);
    historyMetaBox = Hive.box(kHistoryMetaBox);
    historyLazyBox = Hive.lazyBox(kHistoryLazyBox);
    apiSpecsBox = Hive.box(kApiSpecsBox);
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

  Future clearAllHistory() async {
    await historyMetaBox.clear();
    await historyLazyBox.clear();
  }

  Future clear() async {
    await dataBox.clear();
    await environmentBox.clear();
    await historyMetaBox.clear();
    await historyLazyBox.clear();
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
    var apiSpecIds = getApiSpecIds();
    for (var key in apiSpecsBox.keys.toList()) {
      if (key != kApiSpecsBoxIds && !apiSpecIds.contains(key)) {
        await apiSpecsBox.delete(key);
      }
    }
  }

  Future<void> storeApiSpecs(Map<String, String> specs) async {
    final ids = specs.keys.toList();
    await apiSpecsBox.put(kApiSpecsBoxIds, ids);
    await apiSpecsBox.putAll(specs);
  }

  List<String> getApiSpecIds() {
    return (apiSpecsBox.get(kApiSpecsBoxIds)?.cast<String>() ?? []);
  }

  String? getApiSpec(String id) {
    return apiSpecsBox.get(id);
  }

  Map<String, String> getAllApiSpecs() {
    try {
      final ids = getApiSpecIds();
      if (ids.isEmpty) return {};

      final result = <String, String>{};
      for (final id in ids) {
        final content = apiSpecsBox.get(id);
        if (content != null && content is String) {
          result[id] = content;
        }
      }
      return result;
    } catch (e) {
      debugPrint('Error getting API specs: $e');
      return {};
    }
  }

  Future<void> clearApiSpecs() async {
    await apiSpecsBox.clear();
  }
}
