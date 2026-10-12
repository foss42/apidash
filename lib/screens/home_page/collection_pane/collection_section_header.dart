import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class CollectionSectionHeader extends ConsumerWidget {
  const CollectionSectionHeader({
    super.key,
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
      color: isActive
          ? colorScheme.surfaceContainerHighest
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          if (!isActive) {
            await ref
                .read(collectionStateNotifierProvider.notifier)
                .ensureActive(collectionId);
          }
          ref
              .read(expandedCollectionIdsProvider.notifier)
              .update((ids) => {...ids, collectionId});
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
                  final expanding = !ref
                      .read(expandedCollectionIdsProvider)
                      .contains(collectionId);
                  if (expanding) {
                    ref
                        .read(collectionCatalogProvider.notifier)
                        .loadCollection(collectionId);
                  }
                  ref.read(expandedCollectionIdsProvider.notifier).update((
                    ids,
                  ) {
                    final next = {...ids};
                    if (next.contains(collectionId)) {
                      next.remove(collectionId);
                    } else {
                      next.add(collectionId);
                    }
                    return next;
                  });
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
                      .read(collectionStateNotifierProvider.notifier)
                      .ensureActive(collectionId);
                  ref.read(collectionStateNotifierProvider.notifier).add();
                  ref
                      .read(expandedCollectionIdsProvider.notifier)
                      .update((ids) => {...ids, collectionId});
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
