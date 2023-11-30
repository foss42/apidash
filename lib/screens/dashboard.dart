import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'home_page/home_page.dart';
import 'intro_page.dart';
import 'settings_page.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final railIdx = ref.watch(navRailIndexStateProvider);
    return Scaffold(
      backgroundColor: kIsWindows ? Colors.transparent : null,
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
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: bottomButton(context, railIdx, 1, Icons.help,
                            Icons.help_outline),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: bottomButton(context, railIdx, 2, Icons.settings,
                            Icons.settings_outlined),
                      ),
                    ],
                  ),
                ),
              ],
              // destinations: const <NavigationRailDestination>[
              //   // NavigationRailDestination(
              //   //   icon: Icon(Icons.home_outlined),
              //   //   selectedIcon: Icon(Icons.home),
              //   //   label: Text('Home'),
              //   // ),
              //   NavigationRailDestination(
              //     icon: Icon(Icons.auto_awesome_mosaic_outlined),
              //     selectedIcon: Icon(Icons.auto_awesome_mosaic),
              //     label: Text('Requests'),
              //   ),
              // ],
            ),
            VerticalDivider(
              thickness: 1,
              width: 1,
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
            Expanded(
              child: IndexedStack(
                alignment: AlignmentDirectional.topCenter,
                index: railIdx,
                children: const [
                  HomePage(),
                  IntroPage(),
                  SettingsPage(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  TextButton bottomButton(
    BuildContext context,
    int railIdx,
    int buttonIdx,
    IconData selectedIcon,
    IconData icon,
  ) {
    bool isSelected = railIdx == buttonIdx;
    return TextButton(
      style: isSelected
          ? TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            )
          : null,
      onPressed: isSelected
          ? null
          : () {
              ref.read(navRailIndexStateProvider.notifier).state = buttonIdx;
            },
      child: Icon(
        isSelected ? selectedIcon : icon,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
