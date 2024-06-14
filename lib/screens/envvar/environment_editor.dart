import 'package:apidash/consts.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/screens/common/main_editor_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentEditor extends ConsumerWidget {
  const EnvironmentEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: context.isMediumWindow
          ? kPb10
          : (kIsMacOS || kIsWindows)
              ? kPt24o8
              : kP8,
      child: Column(
        children: [
          kVSpacer5,
          !context.isMediumWindow
              ? const Padding(
                  padding: kPh4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      EnvironmentDropdown(),
                    ],
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
