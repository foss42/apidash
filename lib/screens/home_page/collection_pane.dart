import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/importer/import_dialog.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import '../common_widgets/common_widgets.dart';

class CollectionPane extends ConsumerWidget {
  const CollectionPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(autoSaveNotifierProvider);
    ref.watch(collectionCatalogProvider);
    final collection = ref.watch(activeCollectionProvider);
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
      return _EmptyCollections(
        onCreate: () => ref
            .read(collectionCatalogProvider.notifier)
            .addCollection(),
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
            _CollectionSection(
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

class _EmptyCollections extends StatelessWidget {
  const _EmptyCollections({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: kP20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_off_outlined,
              size: 36,
              color: colorScheme.onSurfaceVariant,
            ),
            kVSpacer10,
            Text(
              kMsgNoCollections,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            kVSpacer16,
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text(kLabelCreateCollection),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionSection extends ConsumerWidget {
  const _CollectionSection({
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

  List<RequestSummary> _requestSummaries(WidgetRef ref) {
    if (!isActive) {
      return collection.requests;
    }
    ref.watch(activeCollectionProvider);
    final sequence = ref.watch(requestSequenceProvider);
    return ref
        .read(activeCollectionProvider.notifier)
        .summariesForSequence(collectionId, sequence);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isExpanded) {
      ref.read(collectionCatalogProvider.notifier).loadCollection(
            collectionId,
          );
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
        _CollectionSectionHeader(
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

class _CollectionSectionHeader extends ConsumerWidget {
  const _CollectionSectionHeader({
    required this.collectionId,
    required this.name,
    required this.isExpanded,
    required this.isActive,
  });

  final String collectionId;
  final String name;
  final bool isExpanded;
  final bool isActive;

  Future<String?> _showRenameDialog(
    BuildContext context,
    Set<String> takenIds,
  ) async {
    final controller = TextEditingController(text: name);

    String? errorFor(String value) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        return null;
      }
      if (collectionNameHasIllegalChars(trimmed)) {
        return kMsgCollectionNameInvalidChars;
      }
      final candidate = makeCollectionId(trimmed).toLowerCase();
      if (takenIds.any((t) => t.toLowerCase() == candidate)) {
        return kMsgCollectionNameInUse;
      }
      return null;
    }

    try {
      return await showDialog<String>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            final error = errorFor(controller.text);
            final canSubmit =
                controller.text.trim().isNotEmpty && error == null;

            void submit() {
              if (canSubmit) {
                Navigator.of(context).pop(controller.text);
              }
            }

            return AlertDialog(
              title: const Text(kLabelRenameCollection),
              content: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: kLabelCollectionName,
                  errorText: error,
                ),
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => submit(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(kLabelCancel),
                ),
                FilledButton(
                  onPressed: canSubmit ? submit : null,
                  child: const Text(kLabelOk),
                ),
              ],
            );
          },
        ),
      );
    } finally {
      controller.dispose();
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(kLabelDeleteCollection),
        content: Text('Delete "$name" and all its requests?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(kLabelCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(ItemMenuOption.delete.label),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref
          .read(collectionCatalogProvider.notifier)
          .deleteCollection(collectionId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isActive ? colorScheme.surfaceContainerHighest : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          if (!isActive) {
            await ref
                .read(activeCollectionProvider.notifier)
                .ensureActive(collectionId);
          }
          ref.read(expandedCollectionIdsProvider.notifier).update(
                (ids) => {...ids, collectionId},
              );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                iconSize: 18,
                onPressed: () {
                  final expanding =
                      !ref.read(expandedCollectionIdsProvider).contains(
                            collectionId,
                          );
                  if (expanding) {
                    ref
                        .read(collectionCatalogProvider.notifier)
                        .loadCollection(collectionId);
                  }
                  ref.read(expandedCollectionIdsProvider.notifier).update(
                        (ids) {
                          final next = {...ids};
                          if (next.contains(collectionId)) {
                            next.remove(collectionId);
                          } else {
                            next.add(collectionId);
                          }
                          return next;
                        },
                      );
                },
                icon: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                ),
              ),
              Icon(
                Icons.folder_outlined,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              kHSpacer4,
              Expanded(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              IconButton(
                tooltip: kLabelPlusNew,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                iconSize: 18,
                onPressed: () async {
                  await ref
                      .read(activeCollectionProvider.notifier)
                      .ensureActive(collectionId);
                  ref.read(activeCollectionProvider.notifier).add();
                  ref.read(expandedCollectionIdsProvider.notifier).update(
                        (ids) => {...ids, collectionId},
                      );
                },
                icon: const Icon(Icons.add),
              ),
              PopupMenuButton<ItemMenuOption>(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.more_horiz, size: 18),
                splashRadius: 18,
                onSelected: (option) async {
                  if (option == ItemMenuOption.edit) {
                    final takenIds = {
                      ...?ref.read(collectionCatalogProvider)?.keys,
                    }..remove(collectionId);
                    final messenger = ScaffoldMessenger.of(context);
                    final result = await _showRenameDialog(context, takenIds);
                    if (!context.mounted) {
                      return;
                    }
                    if (result != null && result.trim().isNotEmpty) {
                      final ok = await ref
                          .read(collectionCatalogProvider.notifier)
                          .renameCollection(collectionId, result);
                      if (!ok) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text(kMsgCollectionNameInUse),
                          ),
                        );
                      }
                    }
                  }
                  if (option == ItemMenuOption.delete) {
                    if (!context.mounted) {
                      return;
                    }
                    await _confirmDelete(context, ref);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: ItemMenuOption.edit,
                    child: Text(kLabelRenameCollection),
                  ),
                  PopupMenuItem(
                    value: ItemMenuOption.delete,
                    child: Text(ItemMenuOption.delete.label),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RequestItem extends ConsumerWidget {
  const RequestItem({
    super.key,
    required this.summary,
    required this.collectionId,
  });

  final RequestSummary summary;
  final String collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final editRequestId = ref.watch(selectedIdEditStateProvider);
    final id = summary.id;

    return SidebarRequestCard(
      id: id,
      apiType: summary.apiType,
      method: summary.method,
      name: summary.name,
      url: summary.url,
      selectedId: selectedId,
      editRequestId: editRequestId,
      onTap: () async {
        await ref
            .read(activeCollectionProvider.notifier)
            .ensureActive(collectionId);
        ref.read(activeCollectionProvider.notifier).loadRequest(id);
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
            .read(activeCollectionProvider.notifier)
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
          ref.read(activeCollectionProvider.notifier).remove(id: id);
        }
        if (item == ItemMenuOption.duplicate) {
          ref.read(activeCollectionProvider.notifier).duplicate(id: id);
        }
      },
    );
  }
}
