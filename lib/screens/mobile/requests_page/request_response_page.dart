import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/http_utils.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../home_page/collection_pane.dart';
import '../../home_page/editor_pane/editor_default.dart';
import '../../common_widgets/common_widgets.dart';
import 'request_response_page_bottombar.dart';
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
    final ds = DesignSystemProvider.of(context);
    final id = ref.watch(selectedIdStateProvider);
    final name = getRequestTitleFromUrl(
        ref.watch(selectedRequestModelProvider.select((value) => value?.name)));
    final TabController requestTabController =
        useTabController(initialLength: 3, vsync: this);
    return DrawerSplitView(
      scaffoldKey: kHomeScaffoldKey,
      title: Row(
        children: [
          APITypeDropdown(),
          Expanded(
            child: EditorTitle(
              title: name,
              onSelected: (ItemMenuOption item) {
                if (item == ItemMenuOption.edit) {
                  showRenameDialog(context, "Rename Request", name, (val) {
                    ref
                        .read(collectionStateNotifierProvider.notifier)
                        .update(name: val);
                  });
                }
                if (item == ItemMenuOption.delete) {
                  ref.read(collectionStateNotifierProvider.notifier).remove();
                }
                if (item == ItemMenuOption.duplicate) {
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .duplicate();
                }
              },
            ),
          ),
        ],
      ),
      leftDrawerContent: const CollectionPane(),
      actions: [kHSpacer12(ds.scaleFactor)],
      mainContent: id == null
          ? const RequestEditorDefault()
          : RequestTabs(
              controller: requestTabController,
              showDashbot: ref.watch(dashbotShowMobileProvider),
            ),
      bottomNavigationBar: RequestResponsePageBottombar(
        requestTabController: requestTabController,
      ),
      onDrawerChanged: (value) =>
          ref.read(leftDrawerStateProvider.notifier).state = value,
    );
  }
}
