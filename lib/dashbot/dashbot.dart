import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/dashbot/widgets/dashbot_widget.dart';

final dashBotVisibilityProvider = StateProvider<bool>((ref) => false);
final dashBotMinimizedProvider = StateProvider<bool>((ref) => false);

void showDashBotBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const Padding(
      padding: EdgeInsets.all(16.0),
      child: DashBotWidget(),
    ),
  );
}

void toggleDashBotOverlay(WidgetRef ref) {
  ref.read(dashBotVisibilityProvider.notifier).state = true;
  ref.read(dashBotMinimizedProvider.notifier).state = false;
}

class DashBotOverlay extends ConsumerWidget {
  const DashBotOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMinimized = ref.watch(dashBotMinimizedProvider);

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 400,
        height: isMinimized ? 120 : 450,
        child: const DashBotWidget(),
      ),
    );
  }
}

class DashBotFAB extends ConsumerWidget {
  final bool useOverlay;

  const DashBotFAB({this.useOverlay = true, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        if (useOverlay) {
          toggleDashBotOverlay(ref);
        } else {
          showDashBotBottomSheet(context);
        }
      },
      child: const Icon(Icons.help_outline),
    );
  }
}
