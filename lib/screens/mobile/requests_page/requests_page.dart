import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inner_drawer/inner_drawer.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/http_utils.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import '../../home_page/editor_pane/editor_request.dart';
import '../../home_page/editor_pane/editor_pane.dart';
import '../../home_page/editor_pane/url_card.dart';
import '../../home_page/editor_pane/details_card/code_pane.dart';
import '../page_base.dart';

class RequestsPage extends StatelessWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const RequestsPage({super.key, required this.innerDrawerKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        primary: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.format_list_bulleted_rounded),
          onPressed: () {
            innerDrawerKey.currentState!
                .open(direction: InnerDrawerDirection.start);
          },
        ),
        title: const RequestTitle(),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.send_outlined,
              color: Theme.of(context).colorScheme.onBackground,
              size: 20,
            ),
            onPressed: () {
              innerDrawerKey.currentState!
                  .open(direction: InnerDrawerDirection.end);
            },
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: const RequestEditorPane(),
      ),
      bottomNavigationBar: RequestPageBottombar(innerDrawerKey: innerDrawerKey),
    );
  }
}

class RequestTitle extends ConsumerStatefulWidget {
  const RequestTitle({super.key});

  @override
  ConsumerState<RequestTitle> createState() => _RequestTitleState();
}

class _RequestTitleState extends ConsumerState<RequestTitle> {
  @override
  Widget build(BuildContext context) {
    final id = ref.watch(selectedIdStateProvider);
    final name = getRequestTitleFromUrl(
        ref.watch(selectedRequestModelProvider.select((value) => value?.name)),
        capitalize: true);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Material(
        color: Colors.transparent,
        child: RequestCardMenu(
          offset: const Offset(0, 48),
          splashRadius: 0,
          tooltip: name,
          child: Ink(
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

class RequestPageBottombar extends StatelessWidget {
  const RequestPageBottombar({
    super.key,
    required this.innerDrawerKey,
  });

  final GlobalKey<InnerDrawerState> innerDrawerKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60 + MediaQuery.of(context).padding.bottom,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
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
              innerDrawerKey.currentState!
                  .open(direction: InnerDrawerDirection.end);
            },
          ),
        ],
      ),
    );
  }
}
