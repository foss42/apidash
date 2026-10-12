import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/importer/import_dialog.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import '../../common_widgets/common_widgets.dart';
import 'collection_request_list.dart';

class CollectionPane extends ConsumerWidget {
  const CollectionPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(autoSaveNotifierProvider);
    ref.watch(collectionCatalogProvider);
    final collection = ref.watch(collectionStateNotifierProvider);
    var sm = ScaffoldMessenger.of(context);
    if (collection == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding:
          (!context.isMediumWindow && kIsMacOS ? kPt24l4 : kPt8l4) +
          (context.isMediumWindow ? kPb70 : EdgeInsets.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SidebarHeader(
            onAddNew: () {
              ref.read(collectionCatalogProvider.notifier).addCollection();
            },
            onImport: () {
              importToCollectionPane(context, ref, sm);
            },
          ),
          if (context.isMediumWindow) kVSpacer6,
          if (context.isMediumWindow)
            Padding(padding: kPh8, child: EnvironmentDropdown()),
          kVSpacer10,
          SidebarFilter(
            filterHintText: kHintFilterByNameOrUrl,
            onFilterFieldChanged: (value) {
              ref.read(collectionSearchQueryProvider.notifier).state = value
                  .toLowerCase();
            },
          ),
          kVSpacer10,
          const Expanded(child: CollectionRequestList()),
          kVSpacer5,
        ],
      ),
    );
  }
}
