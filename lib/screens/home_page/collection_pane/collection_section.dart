import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'collection_section_header.dart';
import 'request_item.dart';

class CollectionSection extends ConsumerWidget {
  const CollectionSection({
    super.key,
    required this.collectionId,
    required this.collection,
    required this.isExpanded,
    required this.isActive,
    required this.filterQuery,
  });

  final String collectionId;
  final CollectionModel collection;
  final bool isExpanded;
  final bool isActive;
  final String filterQuery;

  List<RequestMetaModel> _requestSummaries(WidgetRef ref) {
    if (!isActive) {
      return collection.requestMetaList;
    }
    ref.watch(collectionStateNotifierProvider);
    final sequence = ref.watch(requestSequenceProvider);
    return ref
        .read(collectionStateNotifierProvider.notifier)
        .summariesForSequence(collectionId, sequence);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isExpanded) {
      ref.read(collectionCatalogProvider.notifier).loadCollection(collectionId);
    }
    final summaries = _requestSummaries(ref);
    final visibleSummaries = filterQuery.isEmpty
        ? summaries
        : summaries.where((summary) {
            return summary.url.toLowerCase().contains(filterQuery) ||
                summary.name.toLowerCase().contains(filterQuery);
          }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CollectionSectionHeader(
          collectionId: collectionId,
          name: collection.name,
          isExpanded: isExpanded,
          isActive: isActive,
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              children: [
                for (final summary in visibleSummaries)
                  Padding(
                    padding: kP1,
                    child: RequestItem(
                      summary: summary,
                      collectionId: collectionId,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
