import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:hive_ce/hive.dart';
import 'package:path/path.dart' as p;
import '../models/cli_models.dart';

class CliStorage {
  static const _dataBoxName = 'apidash-data';
  static const _dataIdsKey = 'ids';
  static const _historyMetaBoxName = 'apidash-history-meta';
  static const _historyIdsKey = 'historyIds';
  static const _historyLazyBoxName = 'apidash-history-lazy';

  static final _random = Random();

  static late Box dataBox;
  static late Box historyMetaBox;
  static late LazyBox historyLazyBox;

  static Future<String?> _readWorkspacePathFromPrefsFile(String prefsPath) async {
    final prefsFile = File(prefsPath);
    if (!await prefsFile.exists()) {
      return null;
    }

    final prefsContent = await prefsFile.readAsString();
    final prefsJson = jsonDecode(prefsContent);
    if (prefsJson is! Map) {
      return null;
    }

    final settingsRaw = prefsJson['flutter.apidash-settings'] ??
        prefsJson['apidash-settings'];
    if (settingsRaw == null) {
      return null;
    }

    Map? settingsJson;
    if (settingsRaw is String) {
      final decoded = jsonDecode(settingsRaw);
      if (decoded is Map) {
        settingsJson = decoded;
      }
    } else if (settingsRaw is Map) {
      settingsJson = settingsRaw;
    }

    if (settingsJson == null) {
      return null;
    }

    final workspaceFolderPath = settingsJson['workspaceFolderPath'];
    if (workspaceFolderPath is String && workspaceFolderPath.trim().isNotEmpty) {
      return workspaceFolderPath.trim();
    }

    return null;
  }

  static Future<String?> _getAppWorkspaceFolderPath() async {
    try {
      final appData = Platform.environment['APPDATA'];
      final home = Platform.environment['USERPROFILE'] ??
          Platform.environment['HOME'];

      final roamingDir = (appData != null && appData.isNotEmpty)
          ? appData
          : (home != null
              ? p.join(home, 'AppData', 'Roaming')
              : null);
      if (roamingDir == null) {
        return null;
      }

      final candidatePrefsPaths = <String>[
        p.join(
          roamingDir,
          'com.example',
          'apidash',
          'shared_preferences.json',
        ),
        p.join(
          roamingDir,
          'io.github.foss42.apidash',
          'shared_preferences.json',
        ),
      ];

      for (final prefsPath in candidatePrefsPaths) {
        final workspacePath = await _readWorkspacePathFromPrefsFile(prefsPath);
        if (workspacePath != null) {
          return workspacePath;
        }
      }
    } catch (_) {
      // Ignore errors reading the preferences
    }
    return null;
  }

  static Future<void> init() async {
    Hive.init(await _resolveHivePath());
    dataBox = await Hive.openBox(_dataBoxName);
    historyMetaBox = await Hive.openBox(_historyMetaBoxName);
    historyLazyBox = await Hive.openLazyBox(_historyLazyBoxName);
  }

  static Future<String> _resolveHivePath() async {
    final workspacePath = Platform.environment['APIDASH_WORKSPACE_PATH'];
    if (workspacePath != null && workspacePath.trim().isNotEmpty) {
      return workspacePath.trim();
    }

    if (Platform.isWindows) {
      final appWorkspacePath = await _getAppWorkspaceFolderPath();
      if (appWorkspacePath != null && appWorkspacePath.trim().isNotEmpty) {
        return appWorkspacePath.trim();
      }
    }

    final home = Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '.';

    if (Platform.isMacOS) {
      return p.join(
        home,
        'Library',
        'Application Support',
        'io.github.foss42.apidash',
      );
    }
    if (Platform.isLinux) {
      return p.join(home, '.local', 'share', 'io.github.foss42.apidash');
    }
    if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA'];
      if (appData != null && appData.isNotEmpty) {
        return p.join(appData, 'apidash');
      }
      return p.join(home, 'AppData', 'Roaming', 'apidash');
    }

    return p.join(home, '.apidash');
  }

  static List<String> _asStringList(Object? raw) {
    if (raw is List) {
      return raw.whereType<String>().toList();
    }
    return const <String>[];
  }

  static List<CliRequest> getAllRequests() {
    final ids = _asStringList(dataBox.get(_dataIdsKey));
    final requests = <CliRequest>[];

    for (final id in ids) {
      final json = asJsonMap(dataBox.get(id));
      if (json == null) {
        continue;
      }

      try {
        requests.add(CliRequest.fromJson(json));
      } catch (_) {
        // Skip malformed entries instead of breaking all CLI reads.
      }
    }

    return requests;
  }

  static Future<List<CliHistoryEntry>> getHistory() async {
    final ids = _asStringList(historyMetaBox.get(_historyIdsKey));
    final history = <CliHistoryEntry>[];

    for (final id in ids) {
      final metaMap = asJsonMap(historyMetaBox.get(id));
      final historyMap = asJsonMap(await historyLazyBox.get(id));
      history.add(
        CliHistoryEntry.fromHive(
          historyId: id,
          metaMap: metaMap,
          historyMap: historyMap,
        ),
      );
    }

    return history;
  }

  static Future<void> saveToHistory(CliRequest request) async {
    final response = request.httpResponseModel;
    if (response == null) {
      return;
    }

    final historyId = _newHistoryId();
    final metaData = request.toHistoryMetaJson(
      historyId: historyId,
      timeStamp: DateTime.now(),
      responseStatus: response.statusCode ?? 0,
    );

    final historyRequest = request.toHistoryRequestJson(
      historyId: historyId,
      metaData: metaData,
      response: response,
    );

    final historyIds = _asStringList(historyMetaBox.get(_historyIdsKey));
    await historyMetaBox.put(_historyIdsKey, <String>[...historyIds, historyId]);
    await historyMetaBox.put(historyId, metaData);
    await historyLazyBox.put(historyId, historyRequest);
  }

  static String _newHistoryId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final nonce = _random.nextInt(1 << 32).toRadixString(16).padLeft(8, '0');
    return 'h$timestamp$nonce';
  }
}