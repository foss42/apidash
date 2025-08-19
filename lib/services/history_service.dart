import 'dart:developer';

import 'dart:async';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';

import 'hive_services.dart';

abstract class HistoryService {
  Future<void> autoClearHistory({required SettingsModel? settingsModel});
}

class HistoryServiceImpl implements HistoryService {
  @override
  Future<void> autoClearHistory({required SettingsModel? settingsModel}) async {
    try {
      final historyRetentionPeriod = settingsModel?.historyRetentionPeriod;
      DateTime? retentionDate = getRetentionDate(historyRetentionPeriod);
      if (retentionDate == null) return;

      List<String>? historyIds = hiveHandler.getHistoryIds();
      if (historyIds == null || historyIds.isEmpty) return;

      List<String> toRemoveIds = historyIds.where((historyId) {
        var jsonModel = hiveHandler.getHistoryMeta(historyId);
        if (jsonModel != null) {
          var jsonMap = Map<String, Object?>.from(jsonModel);
          HistoryMetaModel historyMetaModelFromJson =
              HistoryMetaModel.fromJson(jsonMap);
          return historyMetaModelFromJson.timeStamp.isBefore(retentionDate);
        }
        return false;
      }).toList();

      if (toRemoveIds.isEmpty) return;

      int batchSize = calculateOptimalBatchSize(toRemoveIds.length);
      final List<List<String>> batches = createBatches(toRemoveIds, batchSize);

      for (var batch in batches) {
        await deleteRecordsInBatches(batch);
      }

      hiveHandler.setHistoryIds(historyIds..removeWhere(toRemoveIds.contains));
    } catch (e, st) {
      log("Error clearing history records",
          name: "autoClearHistory", error: e, stackTrace: st);
    }
  }

  static Future<void> deleteRecordsInBatches(List<String> batch) async {
    try {
      for (var id in batch) {
        hiveHandler.deleteHistoryMeta(id);
        hiveHandler.deleteHistoryRequest(id);
      }
    } catch (e, st) {
      log("Error deleting records in batches",
          name: "deleteRecordsInBatches", error: e, stackTrace: st);
    }
  }
}