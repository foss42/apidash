import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_data_explorer/json_data_explorer.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../consts.dart';

class JsonPreviewerColor {
  const JsonPreviewerColor._();

  static const Color lightRootInfoBox = Color(0x80E1E1E1);
  static const Color lightRootKeyText = Colors.black;
  static const Color lightPropertyKeyText = Colors.black;
  static const Color lightKeySearchHighlightText = Colors.black;
  static const Color lightKeySearchHighlightBackground = Color(0xFFFFEDAD);
  static const Color lightFocusedKeySearchHighlightText = Colors.black;
  static const Color lightFocusedKeySearchHighlightBackground =
      Color(0xFFF29D0B);
  static const Color lightValueText = Color(0xffc41a16);
  static const Color lightValueSearchHighlightText = Color(0xffc41a16);
  static const Color lightValueNum = Color(0xff3F6E74);
  static const Color lightValueBool = Color(0xff1c00cf);
  static const Color lightValueSearchHighlightBackground = Color(0xFFFFEDAD);
  static const Color lightFocusedValueSearchHighlightText = Colors.black;
  static const Color lightFocusedValueSearchHighlightBackground =
      Color(0xFFF29D0B);
  static const Color lightIndentationLineColor =
      Color.fromARGB(255, 213, 213, 213);
  static const Color lightHighlightColor = Color(0xFFF1F1F1);

// Dark colors
  static const Color darkRootInfoBox = Color.fromARGB(255, 83, 13, 19);
  static const Color darkRootKeyText = Color(0xffd6deeb);
  static const Color darkPropertyKeyText = Color(0xffd6deeb);
  static const Color darkKeySearchHighlightText = Color(0xffd6deeb);
  static const Color darkKeySearchHighlightBackground = Color(0xff9b703f);
  static const Color darkFocusedKeySearchHighlightText = Color(0xffd6deeb);
  static const Color darkFocusedKeySearchHighlightBackground =
      Color(0xffc41a16);
  static const Color darkValueText = Color(0xffecc48d);
  static const Color darkValueSearchHighlightText = Color(0xffecc48d);
  static const Color darkValueNum = Color(0xffaddb67);
  static const Color darkValueBool = Color(0xff82aaff);
  static const Color darkValueSearchHighlightBackground = Color(0xff9b703f);
  static const Color darkFocusedValueSearchHighlightText = Color(0xffd6deeb);
  static const Color darkFocusedValueSearchHighlightBackground =
      Color(0xffc41a16);
  static const Color darkIndentationLineColor =
      Color.fromARGB(255, 119, 119, 119);
  static const Color darkHighlightColor = Color.fromARGB(255, 55, 55, 55);
}

final dataExplorerThemeLight = DataExplorerTheme(
  rootKeyTextStyle: kCodeStyle.copyWith(
    color: JsonPreviewerColor.lightRootKeyText,
    fontWeight: FontWeight.bold,
  ),
  propertyKeyTextStyle: kCodeStyle.copyWith(
    color: JsonPreviewerColor.lightPropertyKeyText,
    fontWeight: FontWeight.bold,
  ),
  keySearchHighlightTextStyle: kCodeStyle.copyWith(
    color: JsonPreviewerColor.lightKeySearchHighlightText,
    backgroundColor: JsonPreviewerColor.lightKeySearchHighlightBackground,
    fontWeight: FontWeight.bold,
  ),
  focusedKeySearchHighlightTextStyle: kCodeStyle.copyWith(
    color: JsonPreviewerColor.lightFocusedKeySearchHighlightText,
    backgroundColor:
        JsonPreviewerColor.lightFocusedKeySearchHighlightBackground,
    fontWeight: FontWeight.bold,
  ),
  valueTextStyle: kCodeStyle.copyWith(
    color: JsonPreviewerColor.lightValueText,
  ),
  valueSearchHighlightTextStyle: kCodeStyle.copyWith(
    color: JsonPreviewerColor.lightValueSearchHighlightText,
    backgroundColor: JsonPreviewerColor.lightValueSearchHighlightBackground,
    fontWeight: FontWeight.bold,
  ),
  focusedValueSearchHighlightTextStyle: kCodeStyle.copyWith(
    color: JsonPreviewerColor.lightFocusedValueSearchHighlightText,
    backgroundColor:
        JsonPreviewerColor.lightFocusedValueSearchHighlightBackground,
    fontWeight: FontWeight.bold,
  ),
  indentationLineColor: JsonPreviewerColor.lightIndentationLineColor,
  highlightColor: JsonPreviewerColor.lightHighlightColor,
);

final dataExplorerThemeDark = DataExplorerTheme(
  rootKeyTextStyle: kCodeStyle.copyWith(
    color: JsonPreviewerColor.darkRootKeyText,
    fontWeight: FontWeight.bold,
  ),
  propertyKeyTextStyle: kCodeStyle.copyWith(
    color: JsonPreviewerColor.darkPropertyKeyText,
    fontWeight: FontWeight.bold,
  ),
  keySearchHighlightTextStyle: kCodeStyle.copyWith(
    color: JsonPreviewerColor.darkKeySearchHighlightText,
    backgroundColor: JsonPreviewerColor.darkKeySearchHighlightBackground,
    fontWeight: FontWeight.bold,
  ),
  focusedKeySearchHighlightTextStyle: kCodeStyle.copyWith(
    color: JsonPreviewerColor.darkFocusedKeySearchHighlightText,
    backgroundColor: JsonPreviewerColor.darkFocusedKeySearchHighlightBackground,
    fontWeight: FontWeight.bold,
  ),
  valueTextStyle: kCodeStyle.copyWith(
    color: JsonPreviewerColor.darkValueText,
  ),
  valueSearchHighlightTextStyle: kCodeStyle.copyWith(
    color: JsonPreviewerColor.darkValueSearchHighlightText,
    backgroundColor: JsonPreviewerColor.darkValueSearchHighlightBackground,
    fontWeight: FontWeight.bold,
  ),
  focusedValueSearchHighlightTextStyle: kCodeStyle.copyWith(
    color: JsonPreviewerColor.darkFocusedValueSearchHighlightText,
    backgroundColor:
        JsonPreviewerColor.darkFocusedValueSearchHighlightBackground,
    fontWeight: FontWeight.bold,
  ),
  indentationLineColor: JsonPreviewerColor.darkIndentationLineColor,
  highlightColor: JsonPreviewerColor.darkHighlightColor,
);

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
                rootInformationBuilder: (context, node) =>
                    rootInfoBox(context, node),
                collapsableToggleBuilder: (context, node) => AnimatedRotation(
                  turns: node.isCollapsed ? -0.25 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.arrow_drop_down),
                ),
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
                rootNameFormatter: (dynamic name) => '$name',
                valueStyleBuilder: (value, style) =>
                    valueStyleOverride(context, value, style),
                theme: (Theme.of(context).brightness == Brightness.light)
                    ? dataExplorerThemeLight
                    : dataExplorerThemeDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  PropertyOverrides valueStyleOverride(
    BuildContext context,
    dynamic value,
    TextStyle style,
  ) {
    TextStyle newStyle = style;
    bool isUrl = false;
    if (value.runtimeType.toString() == "num" ||
        value.runtimeType.toString() == "double" ||
        value.runtimeType.toString() == "int") {
      newStyle = style.copyWith(
        color: (Theme.of(context).brightness == Brightness.light)
            ? JsonPreviewerColor.lightValueNum
            : JsonPreviewerColor.darkValueNum,
      );
    } else if (value.runtimeType.toString() == "bool") {
      newStyle = style.copyWith(
        color: (Theme.of(context).brightness == Brightness.light)
            ? JsonPreviewerColor.lightValueBool
            : JsonPreviewerColor.darkValueBool,
      );
    } else {
      isUrl = _valueIsUrl(value);
      if (isUrl) {
        newStyle = style.copyWith(
          decoration: TextDecoration.underline,
          decorationColor: (Theme.of(context).brightness == Brightness.light)
              ? JsonPreviewerColor.lightValueText
              : JsonPreviewerColor.darkValueText,
        );
      }
    }

    return PropertyOverrides(
      style: newStyle,
      onTap: isUrl ? () => _launchUrl(value as String) : null,
    );
  }

  DecoratedBox rootInfoBox(BuildContext context, NodeViewModelState node) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: (Theme.of(context).brightness == Brightness.light)
            ? JsonPreviewerColor.lightRootInfoBox
            : JsonPreviewerColor.darkRootInfoBox,
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 2,
        ),
        child: Text(
          node.isClass ? '{${node.childrenCount}}' : '[${node.childrenCount}]',
          style: kCodeStyle,
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

  Future _launchUrl(String url) {
    return launchUrlString(url);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
