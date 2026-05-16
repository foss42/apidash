import 'package:apidash/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Switches to Requests, expands the bottom integrated shell, and opens/focuses
/// a **session** for [collectionId] (separate PTY per collection, Bruno-style).
void focusIntegratedShell(
  WidgetRef ref,
  String workingDirectory, {
  required String collectionId,
  required String label,
}) {
  final path = workingDirectory.trim();
  if (path.isEmpty) return;
  ref.read(shellTerminalSessionsNotifierProvider.notifier).upsertAndActivate(
        collectionId: collectionId,
        workingDirectory: path,
        label: label,
      );
  ref.read(homeBottomTerminalExpandedProvider.notifier).state = true;
  ref.read(navRailIndexStateProvider.notifier).state = 0;
  ref.read(showTerminalBadgeProvider.notifier).state = false;
}
