import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/dashbot/dashbot.dart';
import 'package:apidash/git/pages/collaboration_page.dart';
import 'common_widgets/common_widgets.dart';
import 'envvar/environment_page.dart';
import 'home_page/home_page.dart';
import 'history/history_page.dart';
import 'settings_page.dart';
import 'terminal/terminal_page.dart';
import 'package:apidash/workflow/pages/workflow_page.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsDesktop) {
      ref.watch(workspaceDiskSyncProvider);
    }
    final railIdx = ref.watch(navRailIndexStateProvider);
    final isDashBotEnabled = ref.watch(
      settingsProvider.select((value) => value.isDashBotEnabled),
    );
    final isDashBotActive = ref.watch(
      dashbotWindowNotifierProvider.select((value) => value.isActive),
    );
    final isDashBotPopped = ref.watch(
      dashbotWindowNotifierProvider.select((value) => value.isPopped),
    );
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Column(
              children: [
                SizedBox(height: kIsMacOS ? 32.0 : 16.0, width: 64),
                SizedBox(
                  width: 64,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    IconButton(
                      tooltip: kLabelRequests,
                      isSelected: railIdx == kNavRailRequestsIndex,
                      onPressed: () {
                        ref.read(navRailIndexStateProvider.notifier).state =
                            kNavRailRequestsIndex;
                      },
                      icon: const Icon(Icons.auto_awesome_mosaic_outlined),
                      selectedIcon: const Icon(Icons.auto_awesome_mosaic),
                    ),
                    Text(
                      kLabelRequests,
                      style: Theme.of(context).textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    kVSpacer10,
                    IconButton(
                      tooltip: kLabelWorkflows,
                      isSelected: railIdx == kNavRailWorkflowsIndex,
                      onPressed: () {
                        ref.read(navRailIndexStateProvider.notifier).state =
                            kNavRailWorkflowsIndex;
                      },
                      icon: const Icon(Icons.account_tree_outlined),
                      selectedIcon: const Icon(Icons.account_tree),
                    ),
                    Text(
                      kLabelWorkflows,
                      style: Theme.of(context).textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    kVSpacer10,
                    IconButton(
                      tooltip: kLabelVariables,
                      isSelected: railIdx == kNavRailVariablesIndex,
                      onPressed: () {
                        ref.read(navRailIndexStateProvider.notifier).state =
                            kNavRailVariablesIndex;
                      },
                      icon: const Icon(Icons.laptop_windows_outlined),
                      selectedIcon: const Icon(Icons.laptop_windows),
                    ),
                    Text(
                      kLabelVariables,
                      style: Theme.of(context).textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    kVSpacer10,
                    IconButton(
                      tooltip: kLabelHistory,
                      isSelected: railIdx == kNavRailHistoryIndex,
                      onPressed: () {
                        ref.read(navRailIndexStateProvider.notifier).state =
                            kNavRailHistoryIndex;
                      },
                      icon: const Icon(Icons.history_outlined),
                      selectedIcon: const Icon(Icons.history_rounded),
                    ),
                    Text(
                      kLabelHistory,
                      style: Theme.of(context).textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    kVSpacer10,
                    if (kIsDesktop) ...[
                      IconButton(
                        tooltip: kLabelCollaboration,
                        isSelected: railIdx == kNavRailCollaborationIndex,
                        onPressed: () {
                          ref.read(navRailIndexStateProvider.notifier).state =
                              kNavRailCollaborationIndex;
                        },
                        icon: const Icon(Icons.cloud_sync),
                        selectedIcon: const Icon(Icons.cloud_sync),
                      ),
                      Text(
                        kLabelCollaboration,
                        style: Theme.of(context).textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      kVSpacer10,
                    ],
                    Badge(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      isLabelVisible:
                          ref.watch(showTerminalBadgeProvider) &&
                          railIdx != kNavRailLogsIndex,
                      child: IconButton(
                        tooltip: kLabelLogs,
                        isSelected: railIdx == kNavRailLogsIndex,
                        onPressed: () {
                          ref.read(navRailIndexStateProvider.notifier).state =
                              kNavRailLogsIndex;
                          ref.read(showTerminalBadgeProvider.notifier).state =
                              false;
                        },
                        icon: const Icon(Icons.terminal_outlined),
                        selectedIcon: const Icon(Icons.terminal),
                      ),
                    ),
                    Text(
                      kLabelLogs,
                      style: Theme.of(context).textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: NavbarButton(
                          railIdx: railIdx,
                          selectedIcon: Icons.help,
                          icon: Icons.help_outline,
                          label: kLabelAbout,
                          showLabel: false,
                          isCompact: true,
                          onTap: () {
                            showAboutAppDialog(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: NavbarButton(
                          railIdx: railIdx,
                          buttonIdx: kNavRailSettingsIndex,
                          selectedIcon: Icons.settings,
                          icon: Icons.settings_outlined,
                          label: kLabelSettings,
                          showLabel: false,
                          isCompact: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            VerticalDivider(
              thickness: 1,
              width: 1,
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
            Expanded(
              child: IndexedStack(
                alignment: AlignmentDirectional.topCenter,
                index: railIdx,
                children: const [
                  HomePage(),
                  WorkflowPage(),
                  EnvironmentPage(),
                  HistoryPage(),
                  CollaborationPage(),
                  TerminalPage(),
                  SettingsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          isDashBotEnabled && !isDashBotActive && isDashBotPopped
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: () => showDashbotWindow(context, ref),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 10,
                ),
                child: DashbotIcons.getDashbotIcon1(),
              ),
            )
          : null,
    );
  }
}
