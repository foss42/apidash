import 'package:apidash/git/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GitLastFetchedNotifier extends Notifier<Map<String, DateTime>> {
  @override
  Map<String, DateTime> build() => {};

  void markFetched(String workspacePath) {
    state = {...state, workspacePath: DateTime.now()};
  }

  DateTime? forWorkspace(String? workspacePath) {
    if (workspacePath == null || workspacePath.isEmpty) return null;
    return state[workspacePath];
  }
}

final gitLastFetchedProvider =
    NotifierProvider<GitLastFetchedNotifier, Map<String, DateTime>>(
  GitLastFetchedNotifier.new,
);

String formatGitLastFetched(DateTime? fetchedAt) {
  if (fetchedAt == null) return kMsgGitNeverFetched;

  final elapsed = DateTime.now().difference(fetchedAt);
  if (elapsed.inSeconds < 60) {
    return kMsgGitLastFetchedJustNow;
  }
  if (elapsed.inMinutes < 60) {
    final minutes = elapsed.inMinutes;
    final unit = minutes == 1 ? 'minute' : 'minutes';
    return 'Last checked: $minutes $unit ago';
  }
  if (elapsed.inHours < 24) {
    final hours = elapsed.inHours;
    final unit = hours == 1 ? 'hour' : 'hours';
    return 'Last checked: $hours $unit ago';
  }
  final days = elapsed.inDays;
  final unit = days == 1 ? 'day' : 'days';
  return 'Last checked: $days $unit ago';
}
