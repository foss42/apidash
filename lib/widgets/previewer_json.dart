import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_explorer/json_explorer.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../consts.dart';
import '../utils/ui_utils.dart';
import 'field_json_search.dart';

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

final jsonExplorerThemeLight = JsonExplorerTheme(
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

final jsonExplorerThemeDark = JsonExplorerTheme(
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
  final dynamic code;

  @override
  State<JsonPreviewer> createState() => _JsonPreviewerState();
}

class _JsonPreviewerState extends State<JsonPreviewer> {
  final searchController = TextEditingController();
  final itemScrollController = ItemScrollController();
  final JsonExplorerStore store = JsonExplorerStore();

  @override
  void initState() {
    super.initState();
    store.buildNodes(widget.code, areAllCollapsed: true);
    store.expandAll();
  }

  @override
  void didUpdateWidget(JsonPreviewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code) {
      store.buildNodes(widget.code, areAllCollapsed: true);
      store.expandAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    return ChangeNotifierProvider.value(
      value: store,
      child: Consumer<JsonExplorerStore>(
        builder: (context, state, child) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              var maxRootNodeWidth =
                  getJsonPreviewerMaxRootNodeWidth(constraints.maxWidth);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest),
                            borderRadius: kBorderRadius8,
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: kPh4,
                                child: Icon(
                                  Icons.search,
                                  size: 16,
                                ),
                              ),
                              Expanded(
                                child: JsonSearchField(
                                  controller: searchController,
                                  onChanged: (term) => state.search(term),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              if (state.searchResults.isNotEmpty)
                                Text(_searchFocusText(),
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              if (state.searchResults.isNotEmpty)
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    store.focusPreviousSearchResult();
                                    _scrollToSearchMatch();
                                  },
                                  icon: const Icon(Icons.arrow_drop_up),
                                ),
                              if (state.searchResults.isNotEmpty)
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    store.focusNextSearchResult();
                                    _scrollToSearchMatch();
                                  },
                                  icon: const Icon(Icons.arrow_drop_down),
                                ),
                            ],
                          ),
                        ),
                      ),
                      ADTextButton(
                        icon: Icons.unfold_more,
                        showLabel:
                            (constraints.minWidth > kMinWindowSize.width) &&
                                !kIsMobile,
                        label: 'Expand All',
                        labelTextStyle: kTextStyleButtonSmall,
                        onPressed:
                            state.areAllExpanded() ? null : state.expandAll,
                      ),
                      ADTextButton(
                        icon: Icons.unfold_less,
                        showLabel:
                            (constraints.minWidth > kMinWindowSize.width) &&
                                !kIsMobile,
                        label: 'Collapse All',
                        labelTextStyle: kTextStyleButtonSmall,
                        onPressed:
                            state.areAllCollapsed() ? null : state.collapseAll,
                      ),
                    ],
                  ),
                  kVSpacer6,
                  Expanded(
                    child: JsonExplorer(
                      nodes: state.displayNodes,
                      itemScrollController: itemScrollController,
                      itemSpacing: 4,
                      rootInformationBuilder: (context, node) =>
                          rootInfoBox(context, node),
                      collapsableToggleBuilder: (context, node) =>
                          AnimatedRotation(
                        turns: node.isCollapsed ? -0.25 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: const Icon(Icons.arrow_drop_down),
                      ),
                      trailingBuilder: (context, node) => node.isFocused
                          ? Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints:
                                    const BoxConstraints(maxHeight: 18),
                                icon: const Icon(
                                  Icons.copy,
                                  size: 18,
                                ),
                                onPressed: () async {
                                  final val = toJson(node);
                                  String toCopy = '';
                                  if (node.isClass ||
                                      node.isArray ||
                                      node.isRoot) {
                                    toCopy = kJsonEncoder.convert(val);
                                  } else {
                                    toCopy = (val.values as Iterable)
                                        .first
                                        .toString();
                                  }
                                  await _copy(toCopy, sm);
                                },
                              ),
                            )
                          : const SizedBox(),
                      valueStyleBuilder: (value, style) =>
                          valueStyleOverride(context, value, style),
                      theme: (Theme.of(context).brightness == Brightness.light)
                          ? jsonExplorerThemeLight
                          : jsonExplorerThemeDark,
                      maxRootNodeWidth: maxRootNodeWidth,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _copy(String text, ScaffoldMessengerState sm) async {
    String msg;
    try {
      await Clipboard.setData(ClipboardData(text: text));
      msg = "Copied";
    } catch (e) {
      msg = "An error occurred";
    }
    sm.hideCurrentSnackBar();
    sm.showSnackBar(getSnackBar(msg));
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
        child: SelectableText(
          node.isClass ? '{${node.childrenCount}}' : '[${node.childrenCount}]',
          style: kCodeStyle,
        ),
      ),
    );
  }

  String _searchFocusText() =>
      '${store.focusedSearchResultIndex + 1}/${store.searchResults.length}';

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

dynamic toJson(
  NodeViewModelState node,
) {
  dynamic res;
  if (node.isRoot) {
    if (node.isClass) {
      res = {};
      for (var i in node.children) {
        res.addAll(toJson(i));
      }
    }
    if (node.isArray) {
      res = [];
      for (var i in node.children) {
        res.add(toJson(i));
      }
    }
  } else {
    res = node.value;
  }

  if (node.parent != null && node.parent!.isArray) {
    return res;
  } else {
    return {node.key: res};
  }
}
