import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/dashbot/dashbot.dart';
import 'common_widgets/common_widgets.dart';
import 'envvar/environment_page.dart';
import 'home_page/home_page.dart';
import 'history/history_page.dart';
import 'settings_page.dart';
import 'terminal/terminal_page.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final railIdx = ref.watch(navRailIndexStateProvider);
    final isDashBotEnabled =
        ref.watch(settingsProvider.select((value) => value.isDashBotEnabled));
    final isDashBotActive = ref
        .watch(dashbotWindowNotifierProvider.select((value) => value.isActive));
    final isDashBotPopped = ref
        .watch(dashbotWindowNotifierProvider.select((value) => value.isPopped));
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: kIsMacOS ? 32.0 : 16.0,
                  width: 64,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Requests',
                      isSelected: railIdx == 0,
                      onPressed: () {
                        ref.read(navRailIndexStateProvider.notifier).state = 0;
                      },
                      icon: const Icon(Icons.auto_awesome_mosaic_outlined),
                      selectedIcon: const Icon(Icons.auto_awesome_mosaic),
                    ),
                    Text(
                      'Requests',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    kVSpacer10,
                    IconButton(
                      tooltip: 'Variables',
                      isSelected: railIdx == 1,
                      onPressed: () {
                        ref.read(navRailIndexStateProvider.notifier).state = 1;
                      },
                      icon: const Icon(Icons.laptop_windows_outlined),
                      selectedIcon: const Icon(Icons.laptop_windows),
                    ),
                    Text(
                      'Variables',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    kVSpacer10,
                    IconButton(
                      tooltip: 'History',
                      isSelected: railIdx == 2,
                      onPressed: () {
                        ref.read(navRailIndexStateProvider.notifier).state = 2;
                      },
                      icon: const Icon(Icons.history_outlined),
                      selectedIcon: const Icon(Icons.history_rounded),
                    ),
                    Text(
                      'History',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    kVSpacer10,
                    Badge(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      isLabelVisible:
                          ref.watch(showTerminalBadgeProvider) && railIdx != 3,
                      child: IconButton(
                        tooltip: 'Logs',
                        isSelected: railIdx == 3,
                        onPressed: () {
                          ref.read(navRailIndexStateProvider.notifier).state =
                              3;
                          ref.read(showTerminalBadgeProvider.notifier).state =
                              false;
                        },
                        icon: const Icon(Icons.terminal_outlined),
                        selectedIcon: const Icon(Icons.terminal),
                      ),
                    ),
                    Text(
                      'Logs',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
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
                          label: 'About',
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
                          buttonIdx: 4,
                          selectedIcon: Icons.settings,
                          icon: Icons.settings_outlined,
                          label: 'Settings',
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
                  EnvironmentPage(),
                  HistoryPage(),
                  TerminalPage(),
                  SettingsPage(),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: isDashBotEnabled &&
              !isDashBotActive &&
              isDashBotPopped
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
