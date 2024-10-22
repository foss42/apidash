import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import '../common_widgets/common_widgets.dart';
import './editor_pane/variables_pane.dart';

class EnvironmentEditor extends ConsumerWidget {
  const EnvironmentEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(selectedEnvironmentIdStateProvider);
    final name = ref
        .watch(selectedEnvironmentModelProvider.select((value) => value?.name));
    return Padding(
      padding: context.isMediumWindow
          ? kPb10
          : (kIsMacOS || kIsWindows)
              ? kPt28o8
              : kP8,
      child: Column(
        children: [
          kVSpacer5,
          !context.isMediumWindow
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    kHSpacer10,
                    Expanded(
                      child: Text(
                        name ?? "",
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    EditorTitleActions(
                      onRenamePressed: () {
                        showRenameDialog(context, "Rename Environment", name,
                            (val) {
                          ref
                              .read(environmentsStateNotifierProvider.notifier)
                              .updateEnvironment(id!, name: val);
                        });
                      },
                      onDuplicatePressed: () => ref
                          .read(environmentsStateNotifierProvider.notifier)
                          .duplicateEnvironment(id!),
                      onDeletePressed: () {
                        ref
                            .read(environmentsStateNotifierProvider.notifier)
                            .removeEnvironment(id!);
                      },
                    ),
                    kHSpacer4,
                  ],
                )
              : const SizedBox.shrink(),
          kVSpacer5,
          Expanded(
            child: Container(
              margin: context.isMediumWindow ? null : kP4,
              child: Card(
                margin: EdgeInsets.zero,
                color: kColorTransparent,
                surfaceTintColor: kColorTransparent,
                shape: context.isMediumWindow
                    ? null
                    : RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                        ),
                        borderRadius: kBorderRadius12,
                      ),
                elevation: 0,
                child: const Padding(
                  padding: kPv6,
                  child: Column(
                    children: [
                      kHSpacer40,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 30),
                          Text("Variable"),
                          SizedBox(width: 30),
                          Text("Value"),
                          SizedBox(width: 40),
                        ],
                      ),
                      kHSpacer40,
                      Divider(),
                      Expanded(child: EditEnvironmentVariables())
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
