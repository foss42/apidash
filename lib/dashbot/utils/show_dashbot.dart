import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dashbot_dashboard.dart';
import '../providers/providers.dart';

void showDashbotWindow(BuildContext context, WidgetRef ref) {
  final isDashbotActive = ref.read(dashbotWindowNotifierProvider).isActive;
  final isDashbotPopped = ref.read(dashbotWindowNotifierProvider).isPopped;
  final windowNotifier = ref.read(dashbotWindowNotifierProvider.notifier);
  if (isDashbotActive) return;
  if (!isDashbotPopped) return;
  final overlay = Overlay.of(context);
  OverlayEntry? entry;

  entry = OverlayEntry(
    builder: (context) => ProviderScope(
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
