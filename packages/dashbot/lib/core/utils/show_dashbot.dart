import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dashbot_dashboard.dart';
import '../providers/dashbot_window_notifier.dart';

void showDashbotWindow(BuildContext context, WidgetRef ref) {
  final isDashbotActive = ref.read(dashbotWindowNotifierProvider).isActive;
  final windowNotifier = ref.read(dashbotWindowNotifierProvider.notifier);
  if (isDashbotActive) return;
  final overlay = Overlay.of(context);
  OverlayEntry? entry;

  entry = OverlayEntry(
    builder:
        (context) => DashbotWindow(
          onClose: () {
            entry?.remove();
            windowNotifier.toggleActive();
          },
        ),
  );
  windowNotifier.toggleActive();
  overlay.insert(entry);
}
