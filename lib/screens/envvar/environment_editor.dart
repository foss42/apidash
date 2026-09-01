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
    final id = ref.watch(selectedEnvironmentIdStateProvider);
    final name = ref.watch(
      selectedEnvironmentModelProvider.select((value) => value?.name),
    );
    return Padding(
      padding: context.isMediumWindow ? kPb10 : (kIsMacOS ? kPt28o8 : kP8),
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
                    const SizedBox(width: 6),
                    EditorTitleActions(
                      onRenamePressed: id != kGlobalEnvironmentId
                          ? () {
                              showRenameDialog(
                                context,
                                kLabelRenameEnvironment,
                                name,
                                (val) {
                                  ref
                                      .read(
                                        environmentsStateNotifierProvider
                                            .notifier,
                                      )
                                      .updateEnvironment(id!, name: val);
                                },
                              );
                            }
                          : null,
                      onDuplicatePressed: () => ref
                          .read(environmentsStateNotifierProvider.notifier)
                          .duplicateEnvironment(id!),
                      onDeletePressed: id == kGlobalEnvironmentId
                          ? null
                          : () {
                              ref
                                  .read(
                                    environmentsStateNotifierProvider.notifier,
                                  )
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
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                        ),
                        borderRadius: kBorderRadius12,
                      ),
                elevation: 0,
                child: Padding(
                  padding: kPv6,
                  child: Column(
                    children: [
                      kHSpacer40,
                      Row(
                        children: [
                          const SizedBox(width: 50),
                           Expanded(
                            flex: 4,
                            child: Text(
                              kLabelVariable,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 35),
                          Expanded(
                            flex: 4,
                            child: Text(
                              kLabelValue,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Secret",
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 50),
                        ],
                      ),
                      kHSpacer40,
                      const Divider(),
                      const Expanded(child: EditEnvironmentVariables()),
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
