import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'storage/workspace_storage.dart';

Future<void> autoClearHistory({SettingsModel? settingsModel}) async {
  final historyRetentionPeriod = settingsModel?.historyRetentionPeriod;
  DateTime? retentionDate = getRetentionDate(historyRetentionPeriod);

  if (retentionDate == null) {
    return;
  } else {
    final allMetas = workspaceStorage.getAllHistoryMetas();
    if (allMetas == null || allMetas.isEmpty) {
      return;
    }

    final toRemoveIds = <String>[];

    for (final entry in allMetas.entries) {
      final jsonMap = Map<String, Object?>.from(entry.value);
      final historyMetaModelFromJson = HistoryMetaModel.fromJson(jsonMap);
      if (historyMetaModelFromJson.timeStamp.isBefore(retentionDate)) {
        toRemoveIds.add(entry.key);
      }
    }

    if (toRemoveIds.isEmpty) {
      return;
    }

    for (final id in toRemoveIds) {
      await workspaceStorage.deleteHistoryRequest(id);
    }
    final remainingMetas = Map<String, Map<String, dynamic>>.from(
      workspaceStorage.getAllHistoryMetas() ?? {},
    )..removeWhere((id, _) => toRemoveIds.contains(id));
    await workspaceStorage.setAllHistoryMetas(
      remainingMetas.isEmpty ? null : remainingMetas,
    );
  }
}
