import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dashbot_dashboard.dart';
import '../providers/dashbot_window_notifier.dart';

/// Optionally pass provider overrides (e.g., dashbotRequestContextProvider)
/// so the host app can feed live context into Dashbot.
void showDashbotWindow(
  BuildContext context,
  WidgetRef ref, {
  List<Override>? overrides,
}) {
  final isDashbotActive = ref.read(dashbotWindowNotifierProvider).isActive;
  final isDashbotPopped = ref.read(dashbotWindowNotifierProvider).isPopped;
  final windowNotifier = ref.read(dashbotWindowNotifierProvider.notifier);
  if (isDashbotActive) return;
  if (!isDashbotPopped) return;
  final overlay = Overlay.of(context);
  OverlayEntry? entry;

  entry = OverlayEntry(
    builder: (context) => ProviderScope(
      overrides: overrides ?? const [],
      child: DashbotWindow(
        onClose: () {
          entry?.remove();
          windowNotifier.toggleActive();
        },
      ),
    ),
  );
  // Mark active and insert overlay
  windowNotifier.toggleActive();
  overlay.insert(entry);
}
