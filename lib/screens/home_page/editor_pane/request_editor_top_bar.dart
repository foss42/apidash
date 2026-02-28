import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import '../../../consts.dart';
import '../../common_widgets/common_widgets.dart';

class RequestEditorTopBar extends ConsumerWidget {
  const RequestEditorTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final name =
        ref.watch(selectedRequestModelProvider.select((value) => value?.name));
    return Padding(
      padding: kP4,
      child: Row(
        children: [
          const APITypeDropdown(),
          kHSpacer10,
          Expanded(
            child: Text(
              name.isNullOrEmpty() ? kUntitled : name!,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          kHSpacer10,
          EditorTitleActions(
            onRenamePressed: () {
              showRenameDialog(context, "Rename Request", name, (val) {
                ref
                    .read(collectionStateNotifierProvider.notifier)
                    .update(name: val);
              });
            },
            onDuplicatePressed: () =>
                ref.read(collectionStateNotifierProvider.notifier).duplicate(),
            onDeletePressed: () =>
                ref.read(collectionStateNotifierProvider.notifier).remove(),
          ),
          kHSpacer10,
          const EnvironmentDropdown(),
        ],
      ),
    );
  }
}
