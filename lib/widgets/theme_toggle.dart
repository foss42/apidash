import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current dark mode status
    final isDarkMode = ref.watch(settingsProvider.select((v) => v.isDark));

    return IconButton(
      // Switch icon based on state
      icon: Icon(
        isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
        color: isDarkMode ? Colors.amber : Colors.indigo,
      ),
      tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      onPressed: () {
        // Toggle the boolean value in your SettingsProvider
        ref.read(settingsProvider.notifier).update(isDark: !isDarkMode);
      },
    );
  }
}
