import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import '../common_widgets/common_widgets.dart';
import './editor_pane/variables_pane.dart';

class EnvironmentEditor extends ConsumerWidget {
  const EnvironmentEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ds = DesignSystemProvider.of(context);
    final id = ref.watch(selectedEnvironmentIdStateProvider);
    final name = ref
        .watch(selectedEnvironmentModelProvider.select((value) => value?.name));
    return Padding(
      padding: context.isMediumWindow
          ? kPb10
          : kIsMacOS
              ? kPt28o8
              : kP8,
      child: Column(
        children: [
          kVSpacer5(ds.scaleFactor),
          !context.isMediumWindow
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    kHSpacer10(ds.scaleFactor),
                    Expanded(
                      child: Text(
                        name ?? "",
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      width: 6*ds.scaleFactor,
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
                      onDeletePressed: id == kGlobalEnvironmentId
                          ? null
                          : () {
                              ref
                                  .read(environmentsStateNotifierProvider
                                      .notifier)
                                  .removeEnvironment(id!);
                            },
                    ),
                    kHSpacer4(ds.scaleFactor),
                  ],
                )
              : const SizedBox.shrink(),
          kVSpacer5(ds.scaleFactor),
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
                child: Padding(
                  padding: kPv6,
                  child: Column(
                    children: [
                      kHSpacer40(ds.scaleFactor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 30*ds.scaleFactor),
                          const Text("Variable"),
                          SizedBox(width: 30*ds.scaleFactor),
                          const Text("Value"),
                          SizedBox(width: 40*ds.scaleFactor),
                        ],
                      ),
                      kHSpacer40(ds.scaleFactor),
                      const Divider(),
                      const Expanded(child: EditEnvironmentVariables())
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
