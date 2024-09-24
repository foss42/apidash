import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import '../common_widgets/common_widgets.dart';
import './editor_pane/variables_pane.dart';

class EnvironmentEditor extends ConsumerWidget {
  const EnvironmentEditor({
    super.key,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    double scaleFactor = settings.scaleFactor;
    final id = ref.watch(selectedEnvironmentIdStateProvider);
    final name = ref
        .watch(selectedEnvironmentModelProvider.select((value) => value?.name));

    return Padding(
      padding: context.isMediumWindow
          ? kPb10 * scaleFactor
          : (kIsMacOS || kIsWindows)
          ? kPt28o8 * scaleFactor
          : kP8 * scaleFactor,
      child: Column(
        children: [
          SizedBox(height: 5 * scaleFactor), // Scaled vertical space
          !context.isMediumWindow
              ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 10 * scaleFactor), // Scaled horizontal space
              Expanded(
                child: Text(
                  name ?? "",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 14 * scaleFactor, // Scaled font size
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(
                width: 6 * scaleFactor, // Scaled space between elements
              ),
              EditorTitleActions(
                scaleFactor: scaleFactor, // Pass scaleFactor to the child widget
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
              SizedBox(width: 4 * scaleFactor), // Scaled horizontal space
            ],
          )
              : const SizedBox.shrink(),
          SizedBox(height: 5 * scaleFactor), // Scaled vertical space
          Expanded(
            child: Container(
              margin: context.isMediumWindow ? null : kP4 * scaleFactor,
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
                  borderRadius: kBorderRadius12 * scaleFactor, // Scaled border radius
                ),
                elevation: 0,
                child: Padding(
                  padding: kPv6 * scaleFactor, // Scaled padding
                  child: Column(
                    children: [
                      SizedBox(height: 40 * scaleFactor), // Scaled spacer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 30 * scaleFactor), // Scaled widths
                          Text(
                            "Variable",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12 * scaleFactor, // Scaled text
                            ),
                          ),
                          SizedBox(width: 30 * scaleFactor),
                          Text(
                            "Value",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12 * scaleFactor, // Scaled text
                            ),
                          ),
                          SizedBox(width: 40 * scaleFactor),
                        ],
                      ),
                      SizedBox(height: 40 * scaleFactor), // Scaled vertical spacer
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
