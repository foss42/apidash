import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/providers/providers.dart';
import 'history_pane.dart';
import 'history_viewer.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyModel = ref.watch(selectedHistoryRequestModelProvider);
    if (context.isMediumWindow) {
      return DrawerSplitView(
        scaffoldKey: scaffoldKey,
        mainContent: const HistoryViewer(),
        title: Text(historyModel?.historyId ?? 'History'),
        leftDrawerContent: const HistoryPane(),
        actions: const [SizedBox(width: 16)],
        onDrawerChanged: (value) =>
            ref.read(leftDrawerStateProvider.notifier).state = value,
      );
    }
    return const Column(
      children: [
        Expanded(
          child: DashboardSplitView(
            sidebarWidget: HistoryPane(),
            mainWidget: HistoryViewer(),
          ),
        ),
      ],
    );
  }
}
