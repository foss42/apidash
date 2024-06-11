import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/window_caption.dart';

class PageBase extends ConsumerWidget {
  final String title;
  final Widget scaffoldBody;
  const PageBase({super.key, required this.title, required this.scaffoldBody});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode =
        ref.watch(settingsProvider.select((value) => value.isDark));
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 70) +
              (kIsWindows || kIsMacOS ? kPt28 : EdgeInsets.zero),
          color: Theme.of(context).colorScheme.surface,
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              primary: true,
              title: Text(title),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom,
              ),
              child: scaffoldBody,
            ),
          ),
        ),
        if (kIsWindows)
          SizedBox(
            height: 29,
            child: WindowCaption(
              backgroundColor: Colors.transparent,
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
            ),
          ),
      ],
    );
  }
}
