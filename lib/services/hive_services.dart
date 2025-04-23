import 'dart:convert';
import 'dart:math';

import 'package:apidash/models/api_explorer_models.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String kDataBox = "apidash-data";
const String kKeyDataBoxIds = "ids";

const String kEnvironmentBox = "apidash-environments";
const String kKeyEnvironmentBoxIds = "environmentIds";

const String kHistoryMetaBox = "apidash-history-meta";
const String kHistoryBoxIds = "historyIds";
const String kHistoryLazyBox = "apidash-history-lazy";

const String kApiSpecsBox = "api_specs_box";
const String kApiSpecsNamesKey = "_spec_names";

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
      await Hive.initFlutter();
    }
    final openHiveBoxesStatus = await openHiveBoxes();
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
    await Hive.openBox<String>(kApiSpecsBox); // api spec box
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
    apiSpecsBox = Hive.box<String>(kApiSpecsBox);
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
  }

  Future<void> cacheApiSpecsCollections(List<ApiCollection> collections) async {
    try {
      await apiSpecsBox.clear();

      await apiSpecsBox.put(
        kApiSpecsNamesKey,
        jsonEncode(collections.map((c) => c.id).toList()),
      );

      // Store each collection as JSON
      for (final collection in collections) {
        await apiSpecsBox.put(
          collection.id,
          jsonEncode(collection.toJson()),
        );
      }

      await _verifyApiSpecsCache(collections);
    } catch (e) {
      await apiSpecsBox.clear();
      throw Exception('API specs cache update failed: $e');
    }
  }

  Future<void> _verifyApiSpecsCache(List<ApiCollection> collections) async {
    try {
      final idsJson = apiSpecsBox.get(kApiSpecsNamesKey);
      if (idsJson == null) throw Exception('Missing API specs IDs list');

      final storedIds = (jsonDecode(idsJson) as List).cast<String>();
      if (storedIds.length != collections.length) {
        throw Exception('API specs cache verification failed: count mismatch');
      }

      // Verify random samples
      final random = Random();
      final samples = collections.length > 5
          ? [
              collections.first,
              collections[random.nextInt(collections.length)],
              collections.last
            ]
          : collections;

      for (final collection in samples) {
        final json = apiSpecsBox.get(collection.id);
        if (json == null) throw Exception('Missing API specs collection');
        ApiCollection.fromJson(jsonDecode(json) as Map<String, dynamic>);
      }
    } catch (e) {
      throw Exception('API specs cache verification failed: $e');
    }
  }

  List<ApiCollection> getCachedApiSpecsCollections() {
    try {
      final idsJson = apiSpecsBox.get(kApiSpecsNamesKey);
      if (idsJson == null) return [];

      final ids = (jsonDecode(idsJson) as List).cast<String>();
      return ids.map((id) {
        final json = apiSpecsBox.get(id);
        if (json == null) throw Exception('Missing API specs collection $id');
        return ApiCollection.fromJson(jsonDecode(json) as Map<String, dynamic>);
      }).toList();
    } catch (e, stackTrace) {
      debugPrint('[API_SPECS_ERROR] Cache read failed: $e\n$stackTrace');
      return [];
    }
  }
}
