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
      body: SafeArea(
        child: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: railIdx,
              groupAlignment: -1.0,
              onDestinationSelected: (int index) {
                setState(() {
                  ref
                      .read(navRailIndexStateProvider.notifier)
                      .update((state) => index);
                });
              },
              labelType: NavigationRailLabelType.all,
              leading: SizedBox(height: kIsMacOS ? 24.0 : 8.0),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextButton(
                      style: (railIdx == null)
                          ? TextButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                            )
                          : null,
                      onPressed: (railIdx == null)
                          ? null
                          : () {
                              ref
                                  .read(navRailIndexStateProvider.notifier)
                                  .update((state) => null);
                            },
                      child: Icon(
                        (railIdx == null)
                            ? Icons.settings
                            : Icons.settings_outlined,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.auto_awesome_mosaic_outlined),
                  selectedIcon: Icon(Icons.auto_awesome_mosaic),
                  label: Text('Requests'),
                ),
              ],
            ),
            VerticalDivider(
              thickness: 1,
              width: 1,
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
            Expanded(
              child: <int?, Widget>{
                null: const SettingsPage(),
                0: const IntroPage(),
                1: const HomePage()
              }[railIdx]!,
            )
          ],
        ),
      ),
    );
  }
}
