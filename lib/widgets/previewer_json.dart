import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_explorer/json_explorer.dart';
import 'package:provider/provider.dart';
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
  final scrollController = ScrollController();
  final JsonExplorerStore store = JsonExplorerStore();
  final Map<NodeViewModelState, GlobalKey> _itemKeys = {};

  @override
  void initState() {
    super.initState();
    store.buildNodes(widget.code);
  }

  @override
  void didUpdateWidget(JsonPreviewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code) {
      _itemKeys.clear();
      store.buildNodes(widget.code);
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
              final jsonExplorerTheme =
                  (Theme.of(context).brightness == Brightness.light)
                      ? jsonExplorerThemeLight
                      : jsonExplorerThemeDark;
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
                    child: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final node in state.displayNodes)
                              RepaintBoundary(
                                child: _JsonPreviewRow(
                                  key: _keyForNode(node),
                                  node: node,
                                  store: store,
                                  itemSpacing: 4,
                                  theme: jsonExplorerTheme,
                                  searchTerm: state.searchTerm,
                                  focusedSearchResult:
                                      state.searchResults.isEmpty
                                          ? null
                                          : state.focusedSearchResult,
                                  maxRootNodeWidth: maxRootNodeWidth,
                                  valueStyleBuilder: (value, style) =>
                                      valueStyleOverride(context, value, style),
                                  onCopyText: (text) => _copy(text, sm),
                                ),
                              ),
                          ],
                        ),
                      ),
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

  String _searchFocusText() =>
      '${store.focusedSearchResultIndex + 1}/${store.searchResults.length}';

  Future<void> _scrollToSearchMatch() async {
    if (store.searchResults.isEmpty) {
      return;
    }

    await _scrollNodeIntoView(store.focusedSearchResult.node);
  }

  GlobalKey _keyForNode(NodeViewModelState node) {
    return _itemKeys.putIfAbsent(node, () => GlobalObjectKey(node));
  }

  Future<void> _scrollNodeIntoView(NodeViewModelState node) async {
    _keyForNode(node);

    await WidgetsBinding.instance.endOfFrame;
    final targetContext = _itemKeys[node]?.currentContext;
    if (targetContext == null) {
      return;
    }

    await Scrollable.ensureVisible(
      targetContext,
      alignment: 0.08,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
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
    scrollController.dispose();
    store.dispose();
    super.dispose();
  }
}

class _JsonPreviewRow extends StatefulWidget {
  const _JsonPreviewRow({
    super.key,
    required this.node,
    required this.store,
    required this.itemSpacing,
    required this.theme,
    required this.searchTerm,
    required this.focusedSearchResult,
    required this.maxRootNodeWidth,
    required this.valueStyleBuilder,
    required this.onCopyText,
  });

  final NodeViewModelState node;
  final JsonExplorerStore store;
  final double itemSpacing;
  final JsonExplorerTheme theme;
  final String searchTerm;
  final SearchResult? focusedSearchResult;
  final double? maxRootNodeWidth;
  final PropertyOverrides Function(dynamic value, TextStyle style)
      valueStyleBuilder;
  final Future<void> Function(String text) onCopyText;

  @override
  State<_JsonPreviewRow> createState() => _JsonPreviewRowState();
}

class _JsonPreviewRowState extends State<_JsonPreviewRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final spacing = widget.itemSpacing / 2;
    final valueStyle =
        widget.valueStyleBuilder(widget.node.value, widget.theme.valueTextStyle);
    final hasInteraction = widget.node.isRoot || valueStyle.onTap != null;

    return MouseRegion(
      cursor: hasInteraction ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: hasInteraction
            ? () {
                if (valueStyle.onTap != null && !widget.node.isRoot) {
                  valueStyle.onTap!.call();
                  return;
                }
                if (widget.node.isRoot) {
                  if (widget.node.isCollapsed) {
                    widget.store.expandNode(widget.node);
                  } else {
                    widget.store.collapseNode(widget.node);
                  }
                }
              }
            : null,
        child: Container(
          color: _isHovered ? widget.theme.highlightColor : null,
          padding: EdgeInsets.symmetric(vertical: spacing),
          child: Row(
            crossAxisAlignment: widget.node.isRoot
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              SizedBox(width: _indentationWidth(widget.node, widget.theme)),
              if (widget.node.isRoot)
                SizedBox(
                  width: 24,
                  child: AnimatedRotation(
                    turns: widget.node.isCollapsed ? -0.25 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(Icons.arrow_drop_down),
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing),
                child: _PreviewText(
                  text: widget.node.key,
                  style: widget.node.isRoot
                      ? widget.theme.rootKeyTextStyle
                      : widget.theme.propertyKeyTextStyle,
                  highlightedText: widget.searchTerm,
                  primaryMatchStyle:
                      widget.theme.focusedKeySearchNodeHighlightTextStyle,
                  secondaryMatchStyle: widget.theme.keySearchHighlightTextStyle,
                  focusedSearchMatchIndex:
                      _focusedMatchIndex(SearchMatchLocation.key),
                  maxWidth: widget.maxRootNodeWidth,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing),
                child: SizedBox(
                  width: 8,
                  child: Text(
                    ':',
                    style: widget.theme.rootKeyTextStyle,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              if (widget.node.isRoot)
                _RootInfoBox(
                  node: widget.node,
                )
              else
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: spacing),
                    child: _PreviewText(
                      text: widget.node.value.toString(),
                      style: valueStyle.style,
                      highlightedText: widget.searchTerm,
                      primaryMatchStyle:
                          widget.theme.focusedValueSearchHighlightTextStyle,
                      secondaryMatchStyle:
                          widget.theme.valueSearchHighlightTextStyle,
                      focusedSearchMatchIndex:
                          _focusedMatchIndex(SearchMatchLocation.value),
                    ),
                  ),
                ),
              SizedBox(
                width: 36,
                child: _isHovered
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(maxHeight: 18),
                          icon: const Icon(
                            Icons.copy,
                            size: 18,
                          ),
                          onPressed: () async {
                            final val = toJson(widget.node);
                            String toCopy = '';
                            if (widget.node.isClass ||
                                widget.node.isArray ||
                                widget.node.isRoot) {
                              toCopy = kJsonEncoder.convert(val);
                            } else {
                              toCopy = (val.values as Iterable).first.toString();
                            }
                            await widget.onCopyText(toCopy);
                          },
                        ),
                      )
                    : null,
                ),
            ],
          ),
        ),
      ),
    );
  }

  int? _focusedMatchIndex(SearchMatchLocation matchLocation) {
    final result = widget.focusedSearchResult;
    if (result == null) {
      return null;
    }
    if (result.node != widget.node || result.matchLocation != matchLocation) {
      return null;
    }
    return result.matchIndex;
  }
}

double _indentationWidth(NodeViewModelState node, JsonExplorerTheme theme) {
  final treeIndent = node.treeDepth * (theme.indentationPadding + 1);
  if (!node.isRoot) {
    return treeIndent +
        (node.treeDepth > 0
            ? theme.indentationPadding * theme.propertyIndentationPaddingFactor
            : theme.indentationPadding);
  }
  return treeIndent + (theme.indentationPadding / 2);
}

class _RootInfoBox extends StatelessWidget {
  const _RootInfoBox({
    required this.node,
  });

  final NodeViewModelState node;

  @override
  Widget build(BuildContext context) {
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
}

class _PreviewText extends StatelessWidget {
  const _PreviewText({
    required this.text,
    required this.style,
    required this.highlightedText,
    required this.primaryMatchStyle,
    required this.secondaryMatchStyle,
    required this.focusedSearchMatchIndex,
    this.maxWidth,
  });

  final String text;
  final TextStyle style;
  final String highlightedText;
  final TextStyle primaryMatchStyle;
  final TextStyle secondaryMatchStyle;
  final int? focusedSearchMatchIndex;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    Widget child;
    final lowerCaseText = text.toLowerCase();
    final lowerCaseQuery = highlightedText.toLowerCase();

    if (highlightedText.isEmpty || !lowerCaseText.contains(lowerCaseQuery)) {
      child = Text(
        text,
        style: style,
        softWrap: true,
      );
    } else {
      final spans = <TextSpan>[];
      var start = 0;

      while (true) {
        var index = lowerCaseText.indexOf(lowerCaseQuery, start);
        index = index >= 0 ? index : text.length;

        if (start != index) {
          spans.add(
            TextSpan(
              text: text.substring(start, index),
              style: style,
            ),
          );
        }

        if (index >= text.length) {
          break;
        }

        spans.add(
          TextSpan(
            text: text.substring(index, index + highlightedText.length),
            style: index == focusedSearchMatchIndex
                ? primaryMatchStyle
                : secondaryMatchStyle,
          ),
        );
        start = index + highlightedText.length;
      }

      child = Text.rich(
        TextSpan(children: spans),
        softWrap: true,
      );
    }

    if (maxWidth == null) {
      return child;
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth!),
      child: child,
    );
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
