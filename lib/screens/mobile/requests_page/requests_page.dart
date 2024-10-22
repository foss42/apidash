import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/http_utils.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../home_page/collection_pane.dart';
import '../../home_page/editor_pane/url_card.dart';
import '../../home_page/editor_pane/editor_default.dart';
import '../../common_widgets/common_widgets.dart';
import 'request_tabs.dart';

class RequestResponsePage extends StatefulHookConsumerWidget {
  const RequestResponsePage({
    super.key,
  });

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
    final TabController requestTabController =
        useTabController(initialLength: 3, vsync: this);
    return DrawerSplitView(
      scaffoldKey: kHomeScaffoldKey,
      title: EditorTitle(
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
          : RequestTabs(
              controller: requestTabController,
            ),
      bottomNavigationBar: RequestResponsePageBottombar(
        requestTabController: requestTabController,
      ),
      onDrawerChanged: (value) =>
          ref.read(leftDrawerStateProvider.notifier).state = value,
    );
  }
}

class RequestResponsePageBottombar extends StatelessWidget {
  const RequestResponsePageBottombar({
    super.key,
    required this.requestTabController,
  });
  final TabController requestTabController;

  @override
  Widget build(BuildContext context) {
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
          children: [
            const Spacer(),
            SizedBox(
              height: 36,
              child: SendRequestButton(
                onTap: () {
                  if (requestTabController.index != 1) {
                    requestTabController.animateTo(1);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
