import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'envvar/environment_page.dart';
import 'home_page/home_page.dart';
import 'intro_page.dart';
import 'settings_page.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final railIdx = ref.watch(navRailIndexStateProvider);
    final mobileScaffoldKey = ref.watch(mobileScaffoldKeyStateProvider);
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
                      isSelected: railIdx == 1,
                      onPressed: () {
                        ref.read(navRailIndexStateProvider.notifier).state = 1;
                      },
                      icon: const Icon(Icons.computer_outlined),
                      selectedIcon: const Icon(Icons.computer_rounded),
                    ),
                    Text(
                      'Variables',
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
                        child: bottomButton(context, ref, railIdx, 2,
                            Icons.help, Icons.help_outline),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: bottomButton(context, ref, railIdx, 3,
                            Icons.settings, Icons.settings_outlined),
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
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            Expanded(
              child: IndexedStack(
                alignment: AlignmentDirectional.topCenter,
                index: railIdx,
                children: [
                  const HomePage(),
                  EnvironmentPage(
                    scaffoldKey: mobileScaffoldKey,
                  ),
                  const IntroPage(),
                  const SettingsPage(),
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
    WidgetRef ref,
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
