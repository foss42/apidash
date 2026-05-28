import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'storage/workspace_storage.dart';

Future<void> autoClearHistory({SettingsModel? settingsModel}) async {
  final historyRetentionPeriod = settingsModel?.historyRetentionPeriod;
  DateTime? retentionDate = getRetentionDate(historyRetentionPeriod);

  if (retentionDate == null) {
    return;
  } else {
    List<String>? historyIds = workspaceStorage.getHistoryIds();
    List<String> toRemoveIds = [];

    if (historyIds == null || historyIds.isEmpty) {
      return;
    }

    for (var historyId in historyIds) {
      var jsonModel = workspaceStorage.getHistoryMeta(historyId);
      if (jsonModel != null) {
        var jsonMap = Map<String, Object?>.from(jsonModel);
        HistoryMetaModel historyMetaModelFromJson =
            HistoryMetaModel.fromJson(jsonMap);
        if (historyMetaModelFromJson.timeStamp.isBefore(retentionDate)) {
          toRemoveIds.add(historyId);
        }
      }
    }

    if (toRemoveIds.isEmpty) {
      return;
    }

    for (var id in toRemoveIds) {
      await workspaceStorage.deleteHistoryRequest(id);
      workspaceStorage.deleteHistoryMeta(id);
    }
    workspaceStorage.setHistoryIds(
        historyIds..removeWhere((id) => toRemoveIds.contains(id)));
  }
}
