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

class RequestEditor extends ConsumerWidget {
  const RequestEditor({
    super.key,
  });


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    double scaleFactor = settings.scaleFactor;
    return context.isMediumWindow
        ? Padding(
      padding: kPb10 * scaleFactor, // Apply scaling to padding
      child: Column(
        children: [
          SizedBox(height: 20 * scaleFactor), // Scaled vertical space
          const Expanded(
            child: EditRequestPane(), // Pass scaleFactor to child
          ),
        ],
      ),
    )
        : Padding(
      padding: (kIsMacOS || kIsWindows ? kPt28o8 : kP8) * scaleFactor,
      child: Column(
        children: [
          RequestEditorTopBar(scaleFactor: scaleFactor),
          const EditorPaneRequestURLCard(),
          SizedBox(height: 10 * scaleFactor), // Scaled vertical space
          const Expanded(
            child: EditorPaneRequestDetailsCard(),
          ),
        ],
      ),
    );
  }
}

class RequestEditorTopBar extends ConsumerWidget {
  const RequestEditorTopBar({
    super.key,
    required this.scaleFactor,
  });

  final double scaleFactor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(selectedIdStateProvider);
    final name = ref.watch(
      selectedRequestModelProvider.select((value) => value?.name),
    );

    return Padding(
      padding: EdgeInsets.only(
        left: 12.0 * scaleFactor,
        top: 4.0 * scaleFactor,
        right: 4.0 * scaleFactor,
        bottom: 4.0 * scaleFactor,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name ?? "",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14 * scaleFactor, // Apply scaled font size
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(
            width: 6 * scaleFactor, // Scaled horizontal space
          ),
          EditorTitleActions(
            scaleFactor: scaleFactor, // Pass scaleFactor to EditorTitleActions
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
          SizedBox(width: 10 * scaleFactor), // Scaled horizontal space
          const EnvironmentDropdown(),
        ],
      ),
    );
  }
}
