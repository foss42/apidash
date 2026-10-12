import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class RequestItem extends ConsumerWidget {
  const RequestItem({
    super.key,
    required this.summary,
    required this.collectionId,
  });

  final RequestMetaModel summary;
  final String collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final editRequestId = ref.watch(selectedIdEditStateProvider);
    final id = summary.id;

    return SidebarRequestCard(
      id: id,
      abbr: summary.abbr,
      abbrColor: getAPIColor(
        summary.apiType,
        method: summary.method,
        brightness: Theme.of(context).brightness,
      ),
      name: summary.name,
      url: summary.url,
      selectedId: selectedId,
      editRequestId: editRequestId,
      onTap: () async {
        await ref
            .read(collectionStateNotifierProvider.notifier)
            .ensureActive(collectionId);
        ref.read(collectionStateNotifierProvider.notifier).loadRequest(id);
        ref.read(selectedIdStateProvider.notifier).state = id;
        kHomeScaffoldKey.currentState?.closeDrawer();
      },
      onSecondaryTap: () {
        ref.read(selectedIdStateProvider.notifier).state = id;
      },
      focusNode: ref.watch(nameTextFieldFocusNodeProvider),
      onChangedNameEditor: (value) {
        value = value.trim();
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(id: editRequestId!, name: value);
      },
      onTapOutsideNameEditor: () {
        ref.read(selectedIdEditStateProvider.notifier).state = null;
      },
      onMenuSelected: (ItemMenuOption item) {
        if (item == ItemMenuOption.edit) {
          ref.read(selectedIdEditStateProvider.notifier).state = id;
          Future.delayed(
            const Duration(milliseconds: 150),
            () => ref
                .read(nameTextFieldFocusNodeProvider.notifier)
                .state
                .requestFocus(),
          );
        }
        if (item == ItemMenuOption.delete) {
          ref.read(collectionStateNotifierProvider.notifier).remove(id: id);
        }
        if (item == ItemMenuOption.duplicate) {
          ref.read(collectionStateNotifierProvider.notifier).duplicate(id: id);
        }
      },
    );
  }
}
