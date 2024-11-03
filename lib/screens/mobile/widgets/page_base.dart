import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/window_caption.dart';

class PageBase extends ConsumerWidget {
  const PageBase({
    super.key,
    required this.title,
    required this.scaffoldBody,
    this.addBottomPadding = true,
  });
  final String title;
  final Widget scaffoldBody;
  final bool addBottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode =
        ref.watch(settingsProvider.select((value) => value.isDark));
    final scaffold = Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        primary: true,
        title: Text(title),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom,
        ),
        child: scaffoldBody,
      ),
    );
    return Stack(
      children: [
        Container(
          padding: (addBottomPadding && context.isMediumWindow
                  ? kPb70
                  : EdgeInsets.zero) +
              (kIsWindows || kIsMacOS ? kPt28 : EdgeInsets.zero),
          color: Theme.of(context).colorScheme.surface,
          child: scaffold,
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
