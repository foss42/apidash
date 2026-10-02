import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'collection_section.dart';
import 'empty_collections.dart';

class CollectionRequestList extends ConsumerStatefulWidget {
  const CollectionRequestList({super.key});

  @override
  ConsumerState<CollectionRequestList> createState() =>
      _CollectionRequestListState();
}

class _CollectionRequestListState extends ConsumerState<CollectionRequestList> {
  late final ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selected = ref.read(selectedCollectionIdStateProvider);
      final expanded = ref.read(expandedCollectionIdsProvider);
      if (selected != null && expanded.isEmpty) {
        ref.read(expandedCollectionIdsProvider.notifier).state = {selected};
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final collectionSequence = ref.watch(collectionSequenceProvider);
    final collections = ref.watch(collectionCatalogProvider)!;
    final expandedIds = ref.watch(expandedCollectionIdsProvider);
    final selectedCollectionId = ref.watch(selectedCollectionIdStateProvider);
    final filterQuery = ref.watch(collectionSearchQueryProvider).trim();
    final alwaysShowScrollbar = ref.watch(
      settingsProvider.select(
        (value) => value.alwaysShowCollectionPaneScrollbar,
      ),
    );

    if (collectionSequence.isEmpty) {
      return EmptyCollections(
        onCreate: () =>
            ref.read(collectionCatalogProvider.notifier).addCollection(),
      );
    }

    return Scrollbar(
      controller: controller,
      thumbVisibility: alwaysShowScrollbar ? true : null,
      radius: const Radius.circular(12),
      child: ListView(
        padding: context.isMediumWindow
            ? EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom,
                right: 8,
              )
            : kPe8,
        controller: controller,
        children: [
          for (final collectionId in collectionSequence)
            CollectionSection(
              collectionId: collectionId,
              collection: collections[collectionId]!,
              isExpanded: expandedIds.contains(collectionId),
              isActive: collectionId == selectedCollectionId,
              filterQuery: filterQuery,
            ),
        ],
      ),
    );
  }
}
