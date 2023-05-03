import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';

class IntroPage extends ConsumerWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode =
        ref.watch(settingsProvider.select((value) => value.isDark));

    return Scaffold(
      body: IntroMessage(
        isDarkMode: isDarkMode,
        onNew: () {
          ref.read(collectionStateNotifierProvider.notifier).add();
        },
        onModeToggle: () async {
          var mode = ref.read(settingsProvider).isDark;
          await ref.read(settingsProvider.notifier).update(isDark: !mode);
        },
      ),
    );
  }
}
