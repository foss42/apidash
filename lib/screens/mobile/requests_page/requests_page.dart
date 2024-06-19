import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/http_utils.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../home_page/collection_pane.dart';
import '../../home_page/editor_pane/url_card.dart';
import '../../home_page/editor_pane/details_card/code_pane.dart';
import '../../home_page/editor_pane/editor_default.dart';
import '../../common/main_editor_widgets.dart';
import '../widgets/page_base.dart';
import 'request_response_tabs.dart';

class RequestResponsePage extends StatefulHookConsumerWidget {
  const RequestResponsePage({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  ConsumerState<RequestResponsePage> createState() =>
      _RequestResponsePageState();
}

class _RequestResponsePageState extends ConsumerState<RequestResponsePage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final id = ref.watch(selectedIdStateProvider);
    final name = getRequestTitleFromUrl(
        ref.watch(selectedRequestModelProvider.select((value) => value?.name)));
    final TabController requestResponseTabController =
        useTabController(initialLength: 2, vsync: this);
    return TwoDrawerScaffold(
      scaffoldKey: widget.scaffoldKey,
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
      actions: const [Padding(padding: kPh8, child: EnvironmentDropdown())],
      mainContent: id == null
          ? const RequestEditorDefault()
          : RequestResponseTabs(
              controller: requestResponseTabController,
            ),
      bottomNavigationBar: RequestResponsePageBottombar(
        requestResponseTabController: requestResponseTabController,
      ),
      onDrawerChanged: (value) =>
          ref.read(leftDrawerStateProvider.notifier).state = value,
    );
  }
}

class RequestResponsePageBottombar extends ConsumerWidget {
  const RequestResponsePageBottombar({
    super.key,
    required this.requestResponseTabController,
  });
  final TabController requestResponseTabController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selecetdId = ref.watch(selectedIdStateProvider);
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
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
              onPressed: selecetdId == null
                  ? null
                  : () {
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
                if (requestResponseTabController.index != 1) {
                  requestResponseTabController.animateTo(1);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
