import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

enum HiveBoxType { normal, lazy }

const String kDataBox = "apidash-data";
const String kKeyDataBoxIds = "ids";
const String kRequestMetaBox = "apidash-request-meta";

const String kEnvironmentBox = "apidash-environments";
const String kKeyEnvironmentBoxIds = "environmentIds";

const String kHistoryMetaBox = "apidash-history-meta";
const String kHistoryBoxIds = "historyIds";
const String kHistoryLazyBox = "apidash-history-lazy";

const String kDashBotBox = "apidash-dashbot-data";
const String kKeyDashBotBoxIds = 'messages';

const kHiveBoxes = [
  (kDataBox, HiveBoxType.lazy),
  (kRequestMetaBox, HiveBoxType.normal),
  (kEnvironmentBox, HiveBoxType.normal),
  (kHistoryMetaBox, HiveBoxType.normal),
  (kHistoryLazyBox, HiveBoxType.lazy),
  (kDashBotBox, HiveBoxType.lazy),
];

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
    for (var box in kHiveBoxes) {
      if (box.$2 == HiveBoxType.normal) {
        await Hive.openBox(box.$1);
      } else if (box.$2 == HiveBoxType.lazy) {
        await Hive.openLazyBox(box.$1);
      }
    }
    return true;
  } catch (e) {
    debugPrint("ERROR OPEN HIVE BOXES: $e");
    return false;
  }
}

Future<void> clearHiveBoxes() async {
  try {
    for (var box in kHiveBoxes) {
      if (Hive.isBoxOpen(box.$1)) {
        if (box.$2 == HiveBoxType.normal) {
          await Hive.box(box.$1).clear();
        } else if (box.$2 == HiveBoxType.lazy) {
          await Hive.lazyBox(box.$1).clear();
        }
      }
    }
  } catch (e) {
    debugPrint("ERROR CLEAR HIVE BOXES: $e");
  }
}

Future<void> deleteHiveBoxes() async {
  try {
    for (var box in kHiveBoxes) {
      if (Hive.isBoxOpen(box.$1)) {
        if (box.$2 == HiveBoxType.normal) {
          await Hive.box(box.$1).deleteFromDisk();
        } else if (box.$2 == HiveBoxType.lazy) {
          await Hive.lazyBox(box.$1).deleteFromDisk();
        }
      }
    }
    await Hive.close();
  } catch (e) {
    debugPrint("ERROR DELETE HIVE BOXES: $e");
  }
}

final hiveHandler = HiveHandler();

class HiveHandler {
  late final LazyBox dataBox;
  late final Box requestMetaBox;
  late final Box environmentBox;
  late final Box historyMetaBox;
  late final LazyBox historyLazyBox;
  late final LazyBox dashBotBox;

  HiveHandler() {
    debugPrint("Trying to open Hive boxes");
    dataBox = Hive.lazyBox(kDataBox);
    requestMetaBox = Hive.box(kRequestMetaBox);
    environmentBox = Hive.box(kEnvironmentBox);
    historyMetaBox = Hive.box(kHistoryMetaBox);
    historyLazyBox = Hive.lazyBox(kHistoryLazyBox);
    dashBotBox = Hive.lazyBox(kDashBotBox);
  }

  dynamic getIds() => requestMetaBox.get(kKeyDataBoxIds);
  Future<void> setIds(List<String>? ids) => requestMetaBox.put(kKeyDataBoxIds, ids);

  List<RequestMetaModel> loadRequestMeta() {
    var ids = getIds();
    if (ids == null || ids is! List) return [];

    List<RequestMetaModel> metaList = [];
    for (var id in ids) {
      var metaJson = requestMetaBox.get(id);
      if (metaJson != null) {
        metaList.add(RequestMetaModel.fromJson(Map<String, dynamic>.from(metaJson)));
      }
    }
    return metaList;
  }

  Future<RequestModel?> loadRequest(String id) async {
    var requestJson = await dataBox.get(id);
    if (requestJson != null) {
      return RequestModel.fromJson(Map<String, dynamic>.from(requestJson));
    }
    return null;
  }

  Future<void> saveRequest(String id, Map<String, dynamic> requestJson) async {
    var requestModel = RequestModel.fromJson(requestJson);
    await dataBox.put(id, requestJson);
    var metaModel = RequestMetaModel(
      id: requestModel.id,
      name: requestModel.name,
      url: requestModel.httpRequestModel?.url ?? "",
      method: requestModel.httpRequestModel?.method ?? HTTPVerb.get,
      apiType: requestModel.apiType,
      responseStatus: requestModel.responseStatus,
      description: requestModel.description,
    );
    await requestMetaBox.put(id, metaModel.toJson());
  }

  Future<void> deleteRequest(String id) async {
    await dataBox.delete(id);
    await requestMetaBox.delete(id);
    await dataBox.delete(id);
  }

  Future<void> setRequestModel(
          String id, Map<String, dynamic>? requestModelJson) async =>
      requestModelJson == null
          ? await deleteRequest(id)
          : await saveRequest(id, requestModelJson);
          
  Future<dynamic> getRequestModel(String id) async => await dataBox.get(id);

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
          String id, Map<String, dynamic>? historyRequestJson) =>
      historyLazyBox.put(id, historyRequestJson);

  Future<void> deleteHistoryRequest(String id) => historyLazyBox.delete(id);

  Future<dynamic> getDashbotMessages() async =>
      await dashBotBox.get(kKeyDashBotBoxIds);
  Future<void> saveDashbotMessages(String messages) =>
      dashBotBox.put(kKeyDashBotBoxIds, messages);

  Future clearAllHistory() async {
    await historyMetaBox.clear();
    await historyLazyBox.clear();
  }

  Future clear() async {
    await dataBox.clear();
    await requestMetaBox.clear();
    await environmentBox.clear();
    await historyMetaBox.clear();
    await historyLazyBox.clear();
    await dashBotBox.clear();
  }

  Future<void> removeUnused() async {
    var ids = getIds();
    if (ids != null) {
      ids = ids as List;
      for (var key in requestMetaBox.keys.toList()) {
        if (key != kKeyDataBoxIds && !ids.contains(key)) {
          await requestMetaBox.delete(key);
        }
      }

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
