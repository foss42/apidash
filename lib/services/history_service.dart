import 'dart:developer';

import 'dart:isolate';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:apidash/consts.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'package:flutter/material.dart' show debugPrint;

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
      final batches = createBatches(toRemoveIds, batchSize);

      final String hiveBoxPath = await getHiveBoxPath();

      for (var batch in batches) {
        if (toRemoveIds.length < kIsolateThreshold) {
          await compute(_deleteRecordsCompute,
              {"batch": batch, "hiveBoxPath": hiveBoxPath});
        } else {
          await _deleteRecordsWithIsolate(
              batch: batch, hiveBoxPath: hiveBoxPath);
        }
      }

      hiveHandler.setHistoryIds(historyIds..removeWhere(toRemoveIds.contains));
    } catch (e, st) {
      log("Error clearing history records",
          name: "autoClearHistory", error: e, stackTrace: st);
    }
  }

  Future<void> _deleteRecordsCompute(Map<String, dynamic> args) async {
    List<String> batch = args['batch'] as List<String>;
    String? hiveBoxPath = args['hiveBoxPath'] as String;

    try {
      Hive.init(hiveBoxPath);
      await openHiveBoxes();

      for (var id in batch) {
        hiveHandler.deleteHistoryMeta(id);
        hiveHandler.deleteHistoryRequest(id);
      }
    } catch (e, st) {
      log("Unable to open hive box",
          name: "_deleteRecordsCompute", error: e, stackTrace: st);
    } finally {
      await closeHiveBoxes();
    }
  }

  Future<void> _deleteRecordsWithIsolate({
    required List<String> batch,
    required String? hiveBoxPath,
  }) async {
    final receivePort = ReceivePort();

    try {
      await Isolate.spawn(
          _isolateTask, [receivePort.sendPort, batch, hiveBoxPath]);

      await receivePort.first;
    } catch (e, st) {
      debugPrint("Unable to instantiate Isolate");
      log("Unable to instantiate Isolate",
          name: "_deleteRecordsWithIsolate", error: e, stackTrace: st);
    } finally {
      receivePort.close();
    }
  }

  Future<void> _isolateTask(List<dynamic> args) async {
    SendPort sendPort = args[0] as SendPort;
    List<String> batch = args[1] as List<String>;
    String? hiveBoxPath = args[2] as String;

    Hive.init(hiveBoxPath);
    await openHiveBoxes();

    try {
      for (var id in batch) {
        hiveHandler.deleteHistoryMeta(id);
        hiveHandler.deleteHistoryRequest(id);
      }
      sendPort.send(true);
    } catch (e, st) {
      sendPort.send(false);
      log("Isolate task failed",
          name: "_isolateTask", error: e, stackTrace: st);
    } finally {
      await closeHiveBoxes();
    }
  }
}
