import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/services.dart';
import '../consts.dart';

@immutable
class UpdateState {
  const UpdateState({this.info, this.skippedVersion});

  final AppUpdateInfo? info;
  final String? skippedVersion;

  /// Whether the update indicator (red dot) should be shown. True only when an
  /// update is available and the user has not skipped that specific version.
  bool get showBadge =>
      info != null &&
      info!.isUpdateAvailable &&
      info!.latestVersion != skippedVersion;

  bool get isUpdateAvailable => info?.isUpdateAvailable ?? false;

  UpdateState copyWith({AppUpdateInfo? info, String? skippedVersion}) {
    return UpdateState(
      info: info ?? this.info,
      skippedVersion: skippedVersion ?? this.skippedVersion,
    );
  }
}

final updateProvider = StateNotifierProvider<UpdateNotifier, UpdateState>(
  (ref) => UpdateNotifier()..check(),
);

class UpdateNotifier extends StateNotifier<UpdateState> {
  UpdateNotifier() : super(const UpdateState());

  /// Silently checks GitHub for a newer release in the background. Any failure
  /// leaves the state untouched so the UI never reacts to a failed check.
  Future<void> check() async {
    if (kIsRunningTests) return;
    final skipped = await getSkippedUpdateVersionFromSharedPrefs();
    final currentVersion = (await PackageInfo.fromPlatform()).version;
    final info = await checkForUpdate(currentVersion);
    if (info == null) return;
    state = UpdateState(info: info, skippedVersion: skipped);
  }

  /// Persists the latest version as skipped so the badge is dismissed until a
  /// newer version is released.
  Future<void> skipCurrentVersion() async {
    final latest = state.info?.latestVersion;
    if (latest == null) return;
    await setSkippedUpdateVersionToSharedPrefs(latest);
    state = state.copyWith(skippedVersion: latest);
  }
}
