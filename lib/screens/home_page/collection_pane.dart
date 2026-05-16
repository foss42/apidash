import 'dart:async';

import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/importer/import_dialog.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/services/file_system_handler.dart';
import 'package:apidash/utils/focus_integrated_shell.dart';
import 'package:apidash/utils/open_external_terminal.dart';
import 'package:apidash_core/apidash_core.dart';
import '../common_widgets/common_widgets.dart';
import '../git/collection_share_dialog.dart';
import '../git/git_panel_dialog.dart';

class CollectionPane extends ConsumerWidget {
  const CollectionPane({super.key});

  Future<bool?> _showNewCollectionChoiceDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Collection'),
        content: const Text('Choose how you want to start.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Local Collection'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Import from GitHub'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateCollectionDialog(
    BuildContext context,
    WidgetRef ref,
    {bool startInImportMode = false}
  ) async {
    if (startInImportMode) {
      final collectionId = await ref
          .read(collectionStateNotifierProvider.notifier)
          .addCollection(name: null);
      if (!context.mounted || collectionId == null) return;
      showDialog<void>(
        context: context,
        builder: (context) => GitPanelDialog(
          collectionId: collectionId,
          startInImportMode: true,
        ),
      );
      return;
    }

    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Collection'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter collection name',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) => Navigator.of(context).pop(value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
    final normalized = name?.trim();
    if (normalized == null || normalized.isEmpty) return;
    final newId = await ref
        .read(collectionStateNotifierProvider.notifier)
        .addCollection(name: normalized);
    if (!context.mounted) return;
    if (newId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A collection with that name already exists.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            onAddNew: () async {
              final import = await _showNewCollectionChoiceDialog(context);
              if (import == null) return;
              if (!context.mounted) return;
              await _showCreateCollectionDialog(
                context,
                ref,
                startInImportMode: import,
              );
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
          const Expanded(child: CollectionsTreeList()),
          kVSpacer5,
        ],
      ),
    );
  }
}

class CollectionsTreeList extends ConsumerStatefulWidget {
  const CollectionsTreeList({super.key});

  @override
  ConsumerState<CollectionsTreeList> createState() => _CollectionsTreeListState();
}

class _CollectionsTreeListState extends ConsumerState<CollectionsTreeList> {
  String? expandedCollectionId;
  bool _didBootstrapExpanded = false;

  @override
  Widget build(BuildContext context) {
    final collections = ref.watch(collectionsStateProvider);
    final activeCollectionId = ref.watch(activeCollectionIdStateProvider);
    final requestItems = ref.watch(collectionStateNotifierProvider) ?? {};
    final requestSequence = ref.watch(requestSequenceProvider);
    final filterQuery = ref.watch(collectionSearchQueryProvider).trim();
    final alwaysShowCollectionPaneScrollbar = ref.watch(
      settingsProvider.select(
        (value) => value.alwaysShowCollectionPaneScrollbar,
      ),
    );

    final ordered = collections.entries.toList();
    if (ordered.isEmpty) {
      return const SizedBox.shrink();
    }
    if (!_didBootstrapExpanded) {
      expandedCollectionId = activeCollectionId ?? ordered.first.key;
      _didBootstrapExpanded = true;
    }

    final scrollController = ScrollController();
    return Scrollbar(
      controller: scrollController,
      thumbVisibility: alwaysShowCollectionPaneScrollbar ? true : null,
      radius: const Radius.circular(12),
      child: ListView.builder(
        controller: scrollController,
        padding: context.isMediumWindow
            ? EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom,
                right: 8,
              )
            : kPe8,
        itemCount: ordered.length,
        itemBuilder: (context, index) {
          final entry = ordered[index];
          final isExpanded = expandedCollectionId == entry.key;
          final isActive = activeCollectionId == entry.key;
          final requestCount =
              isActive ? requestSequence.length : entry.value.requestIds.length;
          final visibleIds = requestSequence.where((id) {
            if (!requestItems.containsKey(id)) return false;
            if (filterQuery.isEmpty) return true;
            final request = requestItems[id]!;
            final name = request.name.toLowerCase();
            final url = (request.httpRequestModel?.url ?? '').toLowerCase();
            return name.contains(filterQuery) || url.contains(filterQuery);
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CollectionHeaderRow(
                collectionId: entry.key,
                anchorContext: context,
                name: entry.value.name,
                requestCount: requestCount,
                isExpanded: isExpanded,
                onTap: () {
                  if (isExpanded) {
                    setState(() => expandedCollectionId = null);
                    return;
                  }
                  setState(() => expandedCollectionId = entry.key);
                  unawaited(
                    ref
                        .read(collectionStateNotifierProvider.notifier)
                        .switchCollection(entry.key),
                  );
                },
                onAddRequest: () {
                  unawaited(
                    ref
                        .read(collectionStateNotifierProvider.notifier)
                        .addRequestToCollection(entry.key),
                  );
                  setState(() => expandedCollectionId = entry.key);
                },
                onDeleteCollection: collections.length <= 1
                    ? null
                    : () {
                        unawaited(
                          ref
                              .read(collectionStateNotifierProvider.notifier)
                              .removeCollection(entry.key),
                        );
                        if (expandedCollectionId == entry.key) {
                          setState(() => expandedCollectionId = null);
                        }
                      },
              ),
              if (isExpanded)
                if (!isActive)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(36, 0, 8, 8),
                    child: Text(
                      'Loading collection...',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                else if (visibleIds.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(36, 0, 8, 8),
                    child: Text(
                      filterQuery.isEmpty
                          ? 'No requests in this collection'
                          : 'No matching requests',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                else
                  ...visibleIds.map((id) {
                    final request = requestItems[id]!;
                    return _CollectionRequestRow(
                      requestId: id,
                      requestModel: request,
                      selected: ref.watch(selectedIdStateProvider) == id,
                    );
                  }),
            ],
          );
        },
      ),
    );
  }
}

class _CollectionHeaderRow extends ConsumerStatefulWidget {
  const _CollectionHeaderRow({
    required this.collectionId,
    required this.anchorContext,
    required this.name,
    required this.requestCount,
    required this.isExpanded,
    required this.onTap,
    required this.onAddRequest,
    required this.onDeleteCollection,
  });

  final String collectionId;
  final BuildContext anchorContext;
  final String name;
  final int requestCount;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onAddRequest;
  final VoidCallback? onDeleteCollection;

  @override
  ConsumerState<_CollectionHeaderRow> createState() =>
      _CollectionHeaderRowState();
}

class _CollectionHeaderRowState extends ConsumerState<_CollectionHeaderRow> {
  bool _quickActionsExpanded = false;

  Future<void> _openShare() async {
    setState(() => _quickActionsExpanded = false);
    await ref
        .read(collectionStateNotifierProvider.notifier)
        .switchCollection(widget.collectionId);
    if (!mounted || !widget.anchorContext.mounted) return;
    await showDialog<void>(
      context: widget.anchorContext,
      builder: (context) => CollectionShareDialog(
        collectionId: widget.collectionId,
        anchorContext: widget.anchorContext,
      ),
    );
  }

  Future<void> _openExternalTerminal() async {
    setState(() => _quickActionsExpanded = false);
    await ref
        .read(collectionStateNotifierProvider.notifier)
        .switchCollection(widget.collectionId);
    if (!mounted) return;
    final git =
        ref.read(collectionsStateProvider)[widget.collectionId]?.gitConnection;
    final cwd = (git != null && git.localRepoPath.isNotEmpty)
        ? git.localRepoPath
        : collectionStorageDirectory(widget.collectionId);
    await openExternalTerminal(cwd);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Opened your default terminal for .command files in this folder.',
        ),
      ),
    );
  }

  Future<void> _openIntegratedShell() async {
    setState(() => _quickActionsExpanded = false);
    await ref
        .read(collectionStateNotifierProvider.notifier)
        .switchCollection(widget.collectionId);
    if (!mounted) return;
    final git =
        ref.read(collectionsStateProvider)[widget.collectionId]?.gitConnection;
    final cwd = (git != null && git.localRepoPath.isNotEmpty)
        ? git.localRepoPath
        : collectionStorageDirectory(widget.collectionId);
    focusIntegratedShell(
      ref,
      cwd,
      collectionId: widget.collectionId,
      label: widget.name,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Expand the integrated $kLabelShell at the bottom of the window — cwd uses this folder.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      widget.isExpanded ? Icons.expand_more : Icons.chevron_right,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.folder_open, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${widget.requestCount}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 2),
          IconButton(
            tooltip: _quickActionsExpanded ? 'Hide share & terminal' : 'Share & terminal',
            onPressed: () =>
                setState(() => _quickActionsExpanded = !_quickActionsExpanded),
            icon: Icon(
              _quickActionsExpanded ? Icons.expand_less : Icons.expand_more,
              size: 20,
            ),
          ),
          if (_quickActionsExpanded) ...[
            IconButton(
              tooltip: 'Share',
              onPressed: () => unawaited(_openShare()),
              icon: const Icon(Icons.share_outlined, size: 18),
            ),
            PopupMenuButton<int>(
              tooltip: 'Terminal',
              icon: const Icon(Icons.terminal_outlined, size: 18),
              onSelected: (value) {
                if (value == 0) unawaited(_openExternalTerminal());
                if (value == 1) unawaited(_openIntegratedShell());
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 0,
                  child: Text('External terminal (default for .command)'),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text('Integrated $kLabelShell (bottom panel)'),
                ),
              ],
            ),
          ],
          const SizedBox(width: 2),
          IconButton(
            tooltip: 'Add request',
            onPressed: widget.onAddRequest,
            icon: const Icon(Icons.add, size: 18),
          ),
          if (widget.onDeleteCollection != null)
            IconButton(
              tooltip: 'Delete collection',
              onPressed: widget.onDeleteCollection,
              icon: const Icon(Icons.delete_outline, size: 18),
            ),
        ],
      ),
    );
  }
}

class _CollectionRequestRow extends ConsumerWidget {
  const _CollectionRequestRow({
    required this.requestId,
    required this.requestModel,
    required this.selected,
  });

  final String requestId;
  final RequestModel requestModel;
  final bool selected;

  Future<void> _renameRequest(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(text: requestModel.name);
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Request'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter request name',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) return;
    ref
        .read(collectionStateNotifierProvider.notifier)
        .update(id: requestId, name: normalized);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final method = requestModel.httpRequestModel?.method;
    final methodText = method?.name.toUpperCase() ?? 'REQ';
    final url = requestModel.httpRequestModel?.url ?? '';
    final displayName = requestModel.name.trim().isEmpty ? url : requestModel.name;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        ref.read(selectedIdStateProvider.notifier).state = requestId;
        kHomeScaffoldKey.currentState?.closeDrawer();
      },
      onDoubleTap: () => _renameRequest(context, ref),
      child: Container(
        margin: const EdgeInsets.fromLTRB(34, 1, 6, 1),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selected
              ? theme.colorScheme.surfaceContainerHighest
              : Colors.transparent,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 34,
              child: Text(
                methodText,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: _methodColor(method),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _methodColor(HTTPVerb? method) {
    switch (method) {
      case HTTPVerb.get:
        return const Color(0xFF4DAA57);
      case HTTPVerb.post:
        return const Color(0xFFCC9A06);
      case HTTPVerb.put:
        return const Color(0xFF4E8CF5);
      case HTTPVerb.delete:
        return const Color(0xFFE35D6A);
      case HTTPVerb.patch:
        return const Color(0xFFB17CFF);
      default:
        return Colors.grey;
    }
  }
}
