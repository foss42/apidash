import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'common_widgets/common_widgets.dart';
import 'envvar/environment_page.dart';
import 'home_page/home_page.dart';
import 'history/history_page.dart';
import 'settings_page.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final railIdx = ref.watch(navRailIndexStateProvider);

    final settings = ref.watch(settingsProvider);
    double scale = settings.scaleFactor;
    double scaledPadding = 16.0 * scale;
    double scaledFontSize = 14.0 * scale;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: kIsMacOS ? 32.0 * scale : 16.0 * scale,
                  width: 64 * scale,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      isSelected: railIdx == 0,
                      onPressed: () {
                        ref.read(navRailIndexStateProvider.notifier).state = 0;
                      },
                      icon: const Icon(Icons.auto_awesome_mosaic_outlined),
                      selectedIcon: const Icon(Icons.auto_awesome_mosaic),
                    ),
                    Text(
                      'Requests',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: scaledFontSize*0.8),
                    ),
                    SizedBox(height: 10.0 * scale),
                    IconButton(
                      isSelected: railIdx == 1,
                      onPressed: () {
                        ref.read(navRailIndexStateProvider.notifier).state = 1;
                      },
                      icon: const Icon(Icons.laptop_windows_outlined),
                      selectedIcon: const Icon(Icons.laptop_windows),
                    ),
                    Text(
                      'Variables',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: scaledFontSize*0.8),
                    ),
                    SizedBox(height: 10.0 * scale),
                    IconButton(
                      isSelected: railIdx == 2,
                      onPressed: () {
                        ref.read(navRailIndexStateProvider.notifier).state = 2;
                      },
                      icon:  const Icon(Icons.history_outlined),
                      selectedIcon: const Icon(Icons.history_rounded),
                    ),
                    Text(
                      'History',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: scaledFontSize*0.8),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: scaledPadding),
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
                        padding: EdgeInsets.only(bottom: scaledPadding),
                        child: NavbarButton(
                          railIdx: railIdx,
                          buttonIdx: 3,
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
              thickness: 1 * scale,
              width: 1 * scale,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            Expanded(
              child: IndexedStack(
                alignment: AlignmentDirectional.topCenter,
                index: railIdx,
                children: const [
                  HomePage(),
                  EnvironmentPage(),
                  HistoryPage(),
                  SettingsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
