import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'details_card/details_card.dart';
import 'details_card/request_pane/request_pane.dart';
import '../../common_widgets/common_widgets.dart';
import 'url_card.dart';

class RequestEditor extends StatelessWidget {
  const RequestEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return context.isMediumWindow
        ? const Padding(
            padding: kPb10,
            child: Column(
              children: [
                kVSpacer20,
                Expanded(
                  child: EditRequestPane(),
                ),
              ],
            ),
          )
        : Padding(
            padding: kIsMacOS || kIsWindows ? kPt28o8 : kP8,
            child: const Column(
              children: [
                RequestEditorTopBar(),
                EditorPaneRequestURLCard(),
                kVSpacer10,
                Expanded(
                  child: EditorPaneRequestDetailsCard(),
                ),
              ],
            ),
          );
  }
}

class RequestEditorTopBar extends ConsumerWidget {
  const RequestEditorTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(selectedIdStateProvider);
    final name =
        ref.watch(selectedRequestModelProvider.select((value) => value?.name));
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
        top: 4.0,
        right: 4.0,
        bottom: 4.0,
      ),
      child: Row(
        children: [
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
              showRenameDialog(context, "Rename Request", name, (val) {
                ref
                    .read(collectionStateNotifierProvider.notifier)
                    .update(id!, name: val);
              });
            },
            onDuplicatePressed: () => ref
                .read(collectionStateNotifierProvider.notifier)
                .duplicate(id!),
            onDeletePressed: () =>
                ref.read(collectionStateNotifierProvider.notifier).remove(id!),
          ),
          kHSpacer10,
          const EnvironmentDropdown(),
        ],
      ),
    );
  }
}
