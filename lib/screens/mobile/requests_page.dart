import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/http_utils.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import '../home_page/collection_pane.dart';
import '../home_page/editor_pane/editor_pane.dart';
import '../home_page/editor_pane/url_card.dart';
import '../home_page/editor_pane/details_card/code_pane.dart';
import '../common/main_editor_widgets.dart';
import 'response_drawer.dart';
import 'widgets/page_base.dart';

class RequestsPage extends ConsumerWidget {
  const RequestsPage({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(selectedIdStateProvider);
    final name = getRequestTitleFromUrl(
        ref.watch(selectedRequestModelProvider.select((value) => value?.name)));
    return TwoDrawerScaffold(
      scaffoldKey: scaffoldKey,
      title: ScaffoldTitle(
        title: name,
        onSelected: (ItemMenuOption item) {
          if (item == ItemMenuOption.edit) {
            showRenameDialog(context, "Rename Request", name, (val) {
              ref
                  .read(collectionStateNotifierProvider.notifier)
                  .update(id!, name: val);
            });
          }
          if (item == ItemMenuOption.delete) {
            ref.read(collectionStateNotifierProvider.notifier).remove(id!);
          }
          if (item == ItemMenuOption.duplicate) {
            ref.read(collectionStateNotifierProvider.notifier).duplicate(id!);
          }
        },
      ),
      leftDrawerContent: const CollectionPane(),
      rightDrawerContent: const ResponseDrawer(),
      mainContent: const RequestEditorPane(),
      bottomNavigationBar: const RequestPageBottombar(),
      onDrawerChanged: (value) =>
          ref.read(leftDrawerStateProvider.notifier).state = value,
    );
  }
}

class RequestPageBottombar extends ConsumerWidget {
  const RequestPageBottombar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 60 + MediaQuery.paddingOf(context).bottom,
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.only(
        bottom: MediaQuery.paddingOf(context).bottom,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onInverseSurface,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton.filledTonal(
            style: IconButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PageBase(
                    title: 'View Code',
                    scaffoldBody: CodePane(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.code_rounded),
          ),
          SendButton(
            onTap: () {
              ref
                  .read(mobileScaffoldKeyStateProvider)
                  .currentState!
                  .openEndDrawer();
            },
          ),
        ],
      ),
    );
  }
}
