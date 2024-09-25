import 'package:apidash/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_page/home_page.dart';
import 'settings_page.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final railIdx = ref.watch(navRailIndexStateProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              color: Theme.of(context).colorScheme.surfaceVariant,
              alignment: Alignment.center,
              child: const Text(
                'API Dash',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 64,
                    child: Column(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              isSelected: railIdx == 0,
                              onPressed: () {
                                ref
                                    .read(navRailIndexStateProvider.notifier)
                                    .state = 0;
                              },
                              icon: const Icon(
                                  Icons.auto_awesome_mosaic_outlined),
                              selectedIcon:
                                  const Icon(Icons.auto_awesome_mosaic),
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
                                child: bottomButton(context, ref, railIdx, 1,
                                    Icons.help, Icons.help_outline),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: bottomButton(context, ref, railIdx, 2,
                                    Icons.settings, Icons.settings_outlined),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                        SettingsPage(),
                      ],
                    ),
                  )
                ],
              ),
            ),
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
