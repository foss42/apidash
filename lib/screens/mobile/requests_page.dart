import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/http_utils.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import '../home_page/collection_pane.dart';
import '../home_page/editor_pane/editor_request.dart';
import '../home_page/editor_pane/editor_pane.dart';
import '../home_page/editor_pane/url_card.dart';
import '../home_page/editor_pane/details_card/code_pane.dart';
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
    return TwoDrawerScaffold(
      scaffoldKey: scaffoldKey,
      title: const RequestTitle(),
      leftDrawerContent: const CollectionPane(),
      rightDrawerContent: const ResponseDrawer(),
      mainContent: const RequestEditorPane(),
      bottomNavigationBar: const RequestPageBottombar(),
      onDrawerChanged: (value) =>
          ref.read(leftDrawerStateProvider.notifier).state = value,
    );
  }
}

class RequestTitle extends ConsumerWidget {
  const RequestTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(selectedIdStateProvider);
    final name = getRequestTitleFromUrl(
        ref.watch(selectedRequestModelProvider.select((value) => value?.name)));
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        color: Colors.transparent,
        child: RequestCardMenu(
          offset: const Offset(0, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          splashRadius: 0,
          tooltip: name,
          child: Ink(
            color: Theme.of(context)
                .colorScheme
                .secondaryContainer
                .withOpacity(0.3),
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 1,
                  ),
                ),
                const Icon(
                  Icons.unfold_more_rounded,
                  size: 20,
                ),
              ],
            ),
          ),
          onSelected: (RequestItemMenuOption item) {
            if (item == RequestItemMenuOption.edit) {
              showRenameDialog(context, name, (val) {
                ref
                    .read(collectionStateNotifierProvider.notifier)
                    .update(id!, name: val);
              });
            }
            if (item == RequestItemMenuOption.delete) {
              ref.read(collectionStateNotifierProvider.notifier).remove(id!);
            }
            if (item == RequestItemMenuOption.duplicate) {
              ref.read(collectionStateNotifierProvider.notifier).duplicate(id!);
            }
          },
        ),
      ),
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
                    addBottomPadding: false,
                  ),
                  fullscreenDialog: true,
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
