import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'json_explorer_store.dart';
import 'json_explorer_theme.dart';

/// Signature for a function that creates a widget based on a
/// [NodeViewModelState] state.
typedef NodeBuilder = Widget Function(
  BuildContext context,
  NodeViewModelState node,
);

/// Signature for a function that takes a generic value and converts it to a
/// string.
typedef Formatter = String Function(dynamic value);

/// Signature for a function that takes a generic value and the current theme
/// property value style and returns a [StyleBuilder] that allows the style
/// and interaction to be changed dynamically.
///
/// See also:
/// * [PropertyStyle]
typedef StyleBuilder = PropertyOverrides Function(
  dynamic value,
  TextStyle style,
);

/// Holds information about a property value style and interaction.
class PropertyOverrides {
  final TextStyle style;
  final VoidCallback? onTap;

  const PropertyOverrides({required this.style, this.onTap});
}

/// A widget to display a list of Json nodes.
///
/// The [JsonExplorerStore] handles the state of the data structure, so a
/// [JsonExplorerStore] must be available through a [Provider] for this widget
/// to fully function, without it, expand and collapse will not work properly.
///
/// {@tool snippet}
/// ```dart
/// JsonExplorerStore store;
/// // ...
/// ChangeNotifierProvider.value(
///   value: store,
///   child:
/// // ...
/// ```
/// {@end-tool}
///
/// And then a [JsonExplorer] can be built using the store data structure:
/// {@tool snippet}
/// ```dart
/// Widget build(BuildContext context) {
///   return Scaffold(
///     appBar: AppBar(
///       title: Text(widget.title),
///     ),
///     body: SafeArea(
///       minimum: const EdgeInsets.all(16),
///       child: ChangeNotifierProvider.value(
///         value: store,
///         child: Consumer<JsonExplorerStore>(
///           builder: (context, state, child) => JsonExplorer(
///             nodes: state.displayNodes,
///           ),
///         ),
///       ),
///     ),
///   );
/// }
/// ```
/// {@end-tool}
class JsonExplorer extends StatelessWidget {
  /// Nodes to be displayed.
  ///
  /// See also:
  /// * [JsonExplorerStore]
  final Iterable<NodeViewModelState> nodes;

  /// Use to control the scroll.
  ///
  /// Used to jump or scroll to a particular position.
  final ItemScrollController? itemScrollController;

  /// Use to listen to scroll position changes.
  final ItemPositionsListener? itemPositionsListener;

  /// Theme used to render the widgets.
  ///
  /// If not set, a default theme will be used.
  final JsonExplorerTheme theme;

  /// A builder to add a widget as a suffix for root nodes.
  ///
  /// This can be used to display useful information such as the number of
  /// children nodes, or to indicate if the node is class or an array
  /// for example.
  final NodeBuilder? rootInformationBuilder;

  /// Build the expand/collapse icons in root nodes.
  ///
  /// If this builder is null, a material [Icons.arrow_right] is displayed for
  /// collapsed nodes and [Icons.arrow_drop_down] for expanded nodes.
  final NodeBuilder? collapsableToggleBuilder;

  /// A builder to add a trailing widget in each node.
  ///
  /// This widget is added to the end of the node on top of the content.
  final NodeBuilder? trailingBuilder;

  /// Customizes how class/array names are formatted as string.
  ///
  /// By default the class and array names are displayed as follows: 'name:'
  final Formatter? rootNameFormatter;

  /// Customizes how property names are formatted as string.
  ///
  /// By default the property names are displayed as follows: 'name:'
  final Formatter? propertyNameFormatter;

  /// Customizes how property values are formatted as string.
  ///
  /// By default the value is converted to a string by calling the .toString()
  /// method.
  final Formatter? valueFormatter;

  /// Customizes a property style and interaction based on its value.
  ///
  /// See also:
  /// * [StyleBuilder]
  final StyleBuilder? valueStyleBuilder;

  /// Sets the spacing between each list item.
  final double itemSpacing;

  /// Sets the scroll physics of the list.
  final ScrollPhysics? physics;

  final double? maxRootNodeWidth;

  const JsonExplorer({
    Key? key,
    required this.nodes,
    this.itemScrollController,
    this.itemPositionsListener,
    this.rootInformationBuilder,
    this.collapsableToggleBuilder,
    this.trailingBuilder,
    this.rootNameFormatter,
    this.propertyNameFormatter,
    this.valueFormatter,
    this.valueStyleBuilder,
    this.itemSpacing = 2,
    this.physics,
    this.maxRootNodeWidth,
    JsonExplorerTheme? theme,
  })  : theme = theme ?? JsonExplorerTheme.defaultTheme,
        super(key: key);

  @override
  Widget build(BuildContext context) => ScrollablePositionedList.builder(
        itemCount: nodes.length,
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        itemBuilder: (context, index) => AnimatedBuilder(
          animation: nodes.elementAt(index),
          builder: (context, child) => DecoratedBox(
            decoration: BoxDecoration(
              color: nodes.elementAt(index).isHighlighted
                  ? theme.highlightColor
                  : null,
            ),
            child: child,
          ),
          child: JsonAttribute(
            node: nodes.elementAt(index),
            rootInformationBuilder: rootInformationBuilder,
            collapsableToggleBuilder: collapsableToggleBuilder,
            trailingBuilder: trailingBuilder,
            rootNameFormatter: rootNameFormatter,
            propertyNameFormatter: propertyNameFormatter,
            valueFormatter: valueFormatter,
            valueStyleBuilder: valueStyleBuilder,
            itemSpacing: itemSpacing,
            theme: theme,
            maxRootNodeWidth: maxRootNodeWidth,
          ),
        ),
        physics: physics,
      );
}

class JsonAttribute extends StatelessWidget {
  /// Node to be displayed.
  final NodeViewModelState node;

  /// A builder to add a widget as a suffix for root nodes.
  ///
  /// This can be used to display useful information such as the number of
  /// children nodes, or to indicate if the node is class or an array
  /// for example.
  final NodeBuilder? rootInformationBuilder;

  /// Build the expand/collapse icons in root nodes.
  ///
  /// If this builder is null, a material [Icons.arrow_right] is displayed for
  /// collapsed nodes and [Icons.arrow_drop_down] for expanded nodes.
  final NodeBuilder? collapsableToggleBuilder;

  /// A builder to add a trailing widget in each node.
  ///
  /// This widget is added to the end of the node on top of the content.
  final NodeBuilder? trailingBuilder;

  /// Customizes how class/array names are formatted as string.
  ///
  /// By default the class and array names are displayed as follows: 'name:'
  final Formatter? rootNameFormatter;

  /// Customizes how property names are formatted as string.
  ///
  /// By default the property names are displayed as follows: 'name:'
  final Formatter? propertyNameFormatter;

  /// Customizes how property values are formatted as string.
  ///
  /// By default the value is converted to a string by calling the .toString()
  /// method.
  final Formatter? valueFormatter;

  /// Customizes a property style and interaction based on its value.
  ///
  /// See also:
  /// * [StyleBuilder]
  final StyleBuilder? valueStyleBuilder;

  /// Sets the spacing between each list item.
  final double itemSpacing;

  /// Theme used to render this widget.
  final JsonExplorerTheme theme;

  final double? maxRootNodeWidth;

  const JsonAttribute({
    Key? key,
    required this.node,
    required this.theme,
    this.rootInformationBuilder,
    this.collapsableToggleBuilder,
    this.trailingBuilder,
    this.rootNameFormatter,
    this.propertyNameFormatter,
    this.valueFormatter,
    this.valueStyleBuilder,
    this.itemSpacing = 2,
    this.maxRootNodeWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchTerm =
        context.select<JsonExplorerStore, String>((store) => store.searchTerm);

    final spacing = itemSpacing / 2;

    final valueStyle = valueStyleBuilder != null
        ? valueStyleBuilder!.call(
            node.value,
            theme.valueTextStyle,
          )
        : PropertyOverrides(style: theme.valueTextStyle);

    final hasInteraction = node.isRoot || valueStyle.onTap != null;

    return MouseRegion(
      cursor: hasInteraction ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (event) {
        node.highlight();
        node.focus();
      },
      onExit: (event) {
        node.highlight(isHighlighted: false);
        node.focus(isFocused: false);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: hasInteraction
            ? () {
                if (valueStyle.onTap != null) {
                  valueStyle.onTap!.call();
                } else {
                  _onTap(context);
                }
              }
            : null,
        child: AnimatedBuilder(
          animation: node,

          /// IntrinsicHeight is not the best solution for this, the performance
          /// hit that we measured is ok for now. We will revisit this in the
          /// future if we fill that we need to improve the node rendering
          /// performance
          builder: (context, child) => Stack(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: node.isRoot
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    _Indentation(
                      node: node,
                      indentationPadding: theme.indentationPadding,
                      propertyPaddingFactor:
                          theme.propertyIndentationPaddingFactor,
                      lineColor: theme.indentationLineColor,
                    ),
                    if (node.isRoot)
                      SizedBox(
                        width: 24,
                        child: collapsableToggleBuilder?.call(context, node) ??
                            _defaultCollapsableToggleBuilder(context, node),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: maxRootNodeWidth != null
                          ? Container(
                              constraints: BoxConstraints(
                                maxWidth: maxRootNodeWidth!,
                              ),
                              child: _RootNodeWidget(
                                node: node,
                                rootNameFormatter: rootNameFormatter,
                                propertyNameFormatter: propertyNameFormatter,
                                searchTerm: searchTerm,
                                theme: theme,
                              ),
                            )
                          : _RootNodeWidget(
                              node: node,
                              rootNameFormatter: rootNameFormatter,
                              propertyNameFormatter: propertyNameFormatter,
                              searchTerm: searchTerm,
                              theme: theme,
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: SizedBox(
                        width: 8,
                        child: SelectableText(
                          ':',
                          style: theme.rootKeyTextStyle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (node.isRoot)
                      rootInformationBuilder?.call(context, node) ??
                          const SizedBox()
                    else
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: spacing),
                          child: _PropertyNodeWidget(
                            node: node,
                            searchTerm: searchTerm,
                            valueFormatter: valueFormatter,
                            style: valueStyle.style,
                            searchHighlightStyle:
                                theme.valueSearchHighlightTextStyle,
                            focusedSearchHighlightStyle:
                                theme.focusedValueSearchHighlightTextStyle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (trailingBuilder != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: trailingBuilder!.call(context, node),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future _onTap(BuildContext context) async {
    if (node.isRoot) {
      final jsonExplorerStore = Provider.of<JsonExplorerStore>(
        context,
        listen: false,
      );
      if (node.isCollapsed) {
        jsonExplorerStore.expandNode(node);
      } else {
        jsonExplorerStore.collapseNode(node);
      }
    }
  }

  /// Default value for [collapsableToggleBuilder]
  ///
  /// A material [Icons.arrow_right] is displayed for collapsed nodes and
  /// [Icons.arrow_drop_down] for expanded nodes.
  static Widget _defaultCollapsableToggleBuilder(
    BuildContext context,
    NodeViewModelState node,
  ) =>
      node.isCollapsed
          ? const Icon(
              Icons.arrow_right,
            )
          : const Icon(
              Icons.arrow_drop_down,
            );
}

/// A [Widget] that renders a node that can be a class or a list.
class _RootNodeWidget extends StatelessWidget {
  final NodeViewModelState node;
  final String searchTerm;
  final Formatter? rootNameFormatter;
  final Formatter? propertyNameFormatter;
  final JsonExplorerTheme theme;

  const _RootNodeWidget({
    Key? key,
    required this.node,
    required this.searchTerm,
    required this.rootNameFormatter,
    required this.propertyNameFormatter,
    required this.theme,
  }) : super(key: key);

  String _keyName() {
    if (node.isRoot) {
      return rootNameFormatter?.call(node.key) ?? node.key;
    }
    return propertyNameFormatter?.call(node.key) ?? node.key;
  }

  /// Gets the index of the focused search match.
  int? _getFocusedSearchMatchIndex(JsonExplorerStore store) {
    if (store.searchResults.isEmpty) {
      return null;
    }

    if (store.focusedSearchResult.node != node) {
      return null;
    }

    // Assert that it's the key and not the value of the node.
    if (store.focusedSearchResult.matchLocation != SearchMatchLocation.key) {
      return null;
    }

    return store.focusedSearchResult.matchIndex;
  }

  @override
  Widget build(BuildContext context) {
    final showHighlightedText = context.select<JsonExplorerStore, bool>(
      (store) => store.searchResults.isNotEmpty,
    );

    final attributeKeyStyle =
        node.isRoot ? theme.rootKeyTextStyle : theme.propertyKeyTextStyle;

    final text = _keyName();

    if (!showHighlightedText) {
      return SelectableText(text, style: attributeKeyStyle);
    }

    final focusedSearchMatchIndex =
        context.select<JsonExplorerStore, int?>(_getFocusedSearchMatchIndex);

    return _HighlightedText(
      text: text,
      highlightedText: searchTerm,
      style: attributeKeyStyle,
      primaryMatchStyle: theme.focusedKeySearchNodeHighlightTextStyle,
      secondaryMatchStyle: theme.keySearchHighlightTextStyle,
      focusedSearchMatchIndex: focusedSearchMatchIndex,
    );
  }
}

/// A [Widget] that renders a leaf node.
class _PropertyNodeWidget extends StatelessWidget {
  final NodeViewModelState node;
  final String searchTerm;
  final Formatter? valueFormatter;
  final TextStyle style;
  final TextStyle searchHighlightStyle;
  final TextStyle focusedSearchHighlightStyle;

  const _PropertyNodeWidget({
    Key? key,
    required this.node,
    required this.searchTerm,
    required this.valueFormatter,
    required this.style,
    required this.searchHighlightStyle,
    required this.focusedSearchHighlightStyle,
  }) : super(key: key);

  /// Gets the index of the focused search match.
  int? _getFocusedSearchMatchIndex(JsonExplorerStore store) {
    if (store.searchResults.isEmpty) {
      return null;
    }

    if (store.focusedSearchResult.node != node) {
      return null;
    }

    // Assert that it's the value and not the key of the node.
    if (store.focusedSearchResult.matchLocation != SearchMatchLocation.value) {
      return null;
    }

    return store.focusedSearchResult.matchIndex;
  }

  @override
  Widget build(BuildContext context) {
    final showHighlightedText = context.select<JsonExplorerStore, bool>(
      (store) => store.searchResults.isNotEmpty,
    );

    final text = valueFormatter?.call(node.value) ?? node.value.toString();

    if (!showHighlightedText) {
      return SelectableText(text, style: style);
    }

    final focusedSearchMatchIndex =
        context.select<JsonExplorerStore, int?>(_getFocusedSearchMatchIndex);

    return _HighlightedText(
      text: text,
      highlightedText: searchTerm,
      style: style,
      primaryMatchStyle: focusedSearchHighlightStyle,
      secondaryMatchStyle: searchHighlightStyle,
      focusedSearchMatchIndex: focusedSearchMatchIndex,
    );
  }
}

/// Creates the indentation lines and padding of each node depending on its
/// [node.treeDepth] and whether or not the node is a root node.
class _Indentation extends StatelessWidget {
  /// Current node view model
  final NodeViewModelState node;

  /// The padding of each indentation, this change the spacing between each
  /// [node.treeDepth] and the spacing between lines.
  final double indentationPadding;

  /// Color used to render the indentation lines.
  final Color lineColor;

  /// A padding factor to be applied on non root nodes, so its properties have
  /// extra padding steps.
  final double propertyPaddingFactor;

  const _Indentation({
    Key? key,
    required this.node,
    required this.indentationPadding,
    this.lineColor = Colors.grey,
    this.propertyPaddingFactor = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const lineWidth = 1.0;
    return Row(
      children: [
        for (int i = 0; i < node.treeDepth; i++)
          Container(
            margin: EdgeInsets.only(
              right: indentationPadding,
            ),
            width: lineWidth,
            color: lineColor,
          ),
        if (!node.isRoot)
          SizedBox(
            width: node.treeDepth > 0
                ? indentationPadding * propertyPaddingFactor
                : indentationPadding,
          ),
        if (node.isRoot && !node.isCollapsed) ...[
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.52,
              child: Container(
                width: 1,
                color: lineColor,
              ),
            ),
          ),
          Container(
            height: lineWidth,
            width: (indentationPadding / 2) - lineWidth,
            color: lineColor,
          ),
        ],
        if (node.isRoot && node.isCollapsed)
          SizedBox(
            width: indentationPadding / 2,
          ),
      ],
    );
  }
}

/// Highlights found occurrences of [highlightedText] with [highlightedStyle]
/// in [text].
class _HighlightedText extends StatelessWidget {
  final String text;
  final String highlightedText;

  // The default style when the text or part of it is not highlighted.
  final TextStyle style;

  // The style of the focused search match.
  final TextStyle primaryMatchStyle;

  // The style of the search match that is not focused.
  final TextStyle secondaryMatchStyle;

  // The index of the focused search match.
  final int? focusedSearchMatchIndex;

  const _HighlightedText({
    Key? key,
    required this.text,
    required this.highlightedText,
    required this.style,
    required this.primaryMatchStyle,
    required this.secondaryMatchStyle,
    required this.focusedSearchMatchIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lowerCaseText = text.toLowerCase();
    final lowerCaseQuery = highlightedText.toLowerCase();

    if (highlightedText.isEmpty || !lowerCaseText.contains(lowerCaseQuery)) {
      return SelectableText(text, style: style);
    }

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

    return SelectableText.rich(
      TextSpan(
        children: spans,
      ),
    );
  }
}
