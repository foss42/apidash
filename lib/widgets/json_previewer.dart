import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_data_explorer/json_data_explorer.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class JsonPreviewer extends StatefulWidget {
  const JsonPreviewer({
    super.key,
    required this.code,
  });
  final String code;

  @override
  State<JsonPreviewer> createState() => _JsonPreviewerState();
}

class _JsonPreviewerState extends State<JsonPreviewer> {
  final searchController = TextEditingController();
  final itemScrollController = ItemScrollController();
  final DataExplorerStore store = DataExplorerStore();

  @override
  void initState() {
    super.initState();
    store.buildNodes(jsonDecode(widget.code), areAllCollapsed: true);
    store.expandAll();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: store,
      child: Consumer<DataExplorerStore>(
        builder: (context, state, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,

                    /// Delegates the search to [DataExplorerStore] when
                    /// the text field changes.
                    onChanged: (term) => state.search(term),
                    decoration: const InputDecoration(
                      hintText: 'Search',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                if (state.searchResults.isNotEmpty) Text(_searchFocusText()),
                if (state.searchResults.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      store.focusPreviousSearchResult();
                      _scrollToSearchMatch();
                    },
                    icon: const Icon(Icons.arrow_drop_up),
                  ),
                if (state.searchResults.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      store.focusNextSearchResult();
                      _scrollToSearchMatch();
                    },
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: state.areAllExpanded() ? null : state.expandAll,
                  child: const Text('Expand All'),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                TextButton(
                  onPressed: state.areAllCollapsed() ? null : state.collapseAll,
                  child: const Text('Collapse All'),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Expanded(
              child: JsonDataExplorer(
                nodes: state.displayNodes,
                itemScrollController: itemScrollController,
                itemSpacing: 4,

                /// Builds a widget after each root node displaying the
                /// number of children nodes that it has. Displays `{x}`
                /// if it is a class or `[x]` in case of arrays.
                rootInformationBuilder: (context, node) => DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Color(0x80E1E1E1),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Text(
                      node.isClass
                          ? '{${node.childrenCount}}'
                          : '[${node.childrenCount}]',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF6F6F6F),
                      ),
                    ),
                  ),
                ),

                /// Build an animated collapse/expand indicator. Implicitly
                /// animates the indicator when
                /// [NodeViewModelState.isCollapsed] changes.
                collapsableToggleBuilder: (context, node) => AnimatedRotation(
                  turns: node.isCollapsed ? -0.25 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.arrow_drop_down),
                ),

                /// Builds a trailing widget that copies the node key: value
                ///
                /// Uses [NodeViewModelState.isFocused] to display the
                /// widget only in focused widgets.
                trailingBuilder: (context, node) => node.isFocused
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(maxHeight: 18),
                        icon: const Icon(
                          Icons.copy,
                          size: 18,
                        ),
                        onPressed: () => _printNode(node),
                      )
                    : const SizedBox(),

                /// Creates a custom format for classes and array names.
                rootNameFormatter: (dynamic name) => '$name',

                /// Dynamically changes the property value style and
                /// interaction when an URL is detected.
                valueStyleBuilder: (dynamic value, style) {
                  final isUrl = _valueIsUrl(value);
                  return PropertyOverrides(
                    style: isUrl
                        ? style.copyWith(
                            decoration: TextDecoration.underline,
                          )
                        : style,
                    //onTap: isUrl ? () => _launchUrl(value as String) : null,
                  );
                },

                /// Theme definitions of the json data explorer
                theme: DataExplorerTheme(
                  rootKeyTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  propertyKeyTextStyle: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  keySearchHighlightTextStyle: TextStyle(
                    color: Colors.black,
                    backgroundColor: const Color(0xFFFFEDAD),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  focusedKeySearchHighlightTextStyle: TextStyle(
                    color: Colors.black,
                    backgroundColor: const Color(0xFFF29D0B),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  valueTextStyle: TextStyle(
                    color: const Color(0xFFCA442C),
                    fontSize: 16,
                  ),
                  valueSearchHighlightTextStyle: TextStyle(
                    color: const Color(0xFFCA442C),
                    backgroundColor: const Color(0xFFFFEDAD),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  focusedValueSearchHighlightTextStyle: TextStyle(
                    color: Colors.black,
                    backgroundColor: const Color(0xFFF29D0B),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  indentationLineColor: const Color(0xFFE1E1E1),
                  highlightColor: const Color(0xFFF1F1F1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _searchFocusText() =>
      '${store.focusedSearchResultIndex + 1} of ${store.searchResults.length}';

  void _printNode(NodeViewModelState node) {
    if (node.isRoot) {
      final value = node.isClass ? 'class' : 'array';
      debugPrint('${node.key}: $value');
      return;
    }
    debugPrint('${node.key}: ${node.value}');
  }

  void _scrollToSearchMatch() {
    final index = store.displayNodes.indexOf(store.focusedSearchResult.node);
    if (index != -1) {
      itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  bool _valueIsUrl(dynamic value) {
    if (value is String) {
      return Uri.tryParse(value)?.hasAbsolutePath ?? false;
    }
    return false;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
