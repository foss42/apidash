import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class HistorySidebarHeader extends ConsumerWidget {
  const HistorySidebarHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mobileScaffoldKey = ref.read(mobileScaffoldKeyStateProvider);
    return Padding(
      padding: kPe4,
      child: Row(
        children: [
          kHSpacer10,
          Text(
            "History",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          IconButton(
            tooltip: "Manage History",
            style: IconButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              showHistoryRetentionDialog(
                  context,
                  ref.read(settingsProvider.select(
                      (value) => value.historyRetentionPeriod)), (value) {
                ref.read(settingsProvider.notifier).update(
                      historyRetentionPeriod: value,
                    );
              });
            },
            icon: const Icon(
              Icons.manage_history_rounded,
              size: 20,
            ),
          ),
          context.width <= kMinWindowSize.width
              ? IconButton(
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    minimumSize: const Size(36, 36),
                  ),
                  onPressed: () {
                    mobileScaffoldKey.currentState?.closeDrawer();
                  },
                  icon: const Icon(Icons.chevron_left),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
