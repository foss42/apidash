import 'package:apidash/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final settings = ref.watch(settingsProvider);

      return IconButton(
        icon: settings.isDark
            ? const Icon(
                Icons.dark_mode_rounded,
                color: Colors.indigo,
              )
            : const Icon(
                Icons.light_mode_rounded,
                color: Colors.yellow,
              ),
        onPressed: () {
          ref.read(settingsProvider.notifier).update(isDark: !settings.isDark);
        },
      );
    });
  }
}
