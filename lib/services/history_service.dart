import 'dart:isolate';

import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'hive_services.dart';

Future<void> autoClearHistory({SettingsModel? settingsModel}) async {
  final historyRetentionPeriod = settingsModel?.historyRetentionPeriod;
  DateTime? retentionDate = getRetentionDate(historyRetentionPeriod);

  if (retentionDate == null) {
    return;
  }

  List<String>? historyIds = hiveHandler.getHistoryIds();
  if (historyIds == null || historyIds.isEmpty) {
    return;
  }

  // Collect serializable meta maps on the main isolate (Hive is not isolate-safe).
  final metas = <String, Map<String, Object?>>{};
  for (final historyId in historyIds) {
    final jsonModel = hiveHandler.getHistoryMeta(historyId);
    if (jsonModel != null) {
      metas[historyId] = Map<String, Object?>.from(jsonModel);
    }
  }

  if (metas.isEmpty) {
    return;
  }

  // Heavy filtering of expired entries off the UI/main thread.
  final toRemoveIds = await Isolate.run(
    () => findExpiredHistoryIds(metas, retentionDate),
  );

  if (toRemoveIds.isEmpty) {
    return;
  }

  for (final id in toRemoveIds) {
    await hiveHandler.deleteHistoryRequest(id);
    await hiveHandler.deleteHistoryMeta(id);
  }

  await hiveHandler.setHistoryIds(
    historyIds..removeWhere((id) => toRemoveIds.contains(id)),
  );
}
