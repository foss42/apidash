import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import 'history_empty.dart';
import 'history_sidebar.dart';
import 'history_viewer.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ds = DesignSystemProvider.of(context);
    final historyModel = ref.watch(selectedHistoryRequestModelProvider);
    final title = historyModel != null
        ? getHistoryRequestName(historyModel.metaData)
        : 'History';
    final hasHistoryKeys =
        (ref.watch(historySequenceProvider)?.keys.toList() ?? []).isNotEmpty;
    if (context.isMediumWindow) {
      return DrawerSplitView(
        scaffoldKey: kHisScaffoldKey,
        mainContent:
            hasHistoryKeys ? const HistoryViewer() : const HistoryEmpty(),
        title: Text(title),
        leftDrawerContent: const HistoryPane(),
        actions: [SizedBox(width: 16*ds.scaleFactor)],
        onDrawerChanged: (value) =>
            ref.read(leftDrawerStateProvider.notifier).state = value,
      );
    }
    return Column(
      children: [
        Expanded(
          child: DashboardSplitView(
            sidebarWidget: const HistoryPane(),
            mainWidget:
                hasHistoryKeys ? const HistoryViewer() : const HistoryEmpty(),
          ),
        ),
      ],
    );
  }
}
