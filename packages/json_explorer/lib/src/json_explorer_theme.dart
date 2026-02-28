import 'package:flutter/material.dart';

/// Theme used to display the [JsonExplorer].
@immutable
class JsonExplorerTheme {
  /// Text style used to display json class/arrays key attributes.
  ///
  /// Defaults to [propertyKeyTextStyle] if not set.
  final TextStyle rootKeyTextStyle;

  /// Text style used to display json property key attributes.
  final TextStyle propertyKeyTextStyle;

  /// Text style to display the values of of json attributes.
  final TextStyle valueTextStyle;

  /// Text style use to highlight search result matches on json attribute keys.
  final TextStyle keySearchHighlightTextStyle;

  /// Text style use to highlight search result matches on json attribute
  /// values.
  final TextStyle valueSearchHighlightTextStyle;

  /// Text style used to highlight the current focused search result node key.
  ///
  /// If not set falls back to [keySearchHighlightTextStyle].
  final TextStyle focusedKeySearchNodeHighlightTextStyle;

  /// Text style used to highlight the current focused search result node value.
  ///
  /// If not set falls back to [valueSearchHighlightTextStyle].
  final TextStyle focusedValueSearchHighlightTextStyle;

  /// Indentation lines color.
  final Color indentationLineColor;

  /// Padding used to indent nodes.
  final double indentationPadding;

  /// An extra factor applied on [indentationPadding] used when rendering
  /// properties.
  final double propertyIndentationPaddingFactor;

  /// Cursor hover highlight color.
  ///
  /// null to disable the highlight.
  final Color? highlightColor;

  JsonExplorerTheme({
    TextStyle? rootKeyTextStyle,
    TextStyle? propertyKeyTextStyle,
    TextStyle? keySearchHighlightTextStyle,
    TextStyle? valueTextStyle,
    TextStyle? valueSearchHighlightTextStyle,
    TextStyle? focusedKeySearchHighlightTextStyle,
    TextStyle? focusedValueSearchHighlightTextStyle,
    this.indentationLineColor = Colors.grey,
    this.highlightColor,
    this.indentationPadding = 8.0,
    this.propertyIndentationPaddingFactor = 4,
  })  : rootKeyTextStyle = rootKeyTextStyle ??
            (propertyKeyTextStyle ??
                JsonExplorerTheme.defaultTheme.rootKeyTextStyle),
        propertyKeyTextStyle = propertyKeyTextStyle ??
            JsonExplorerTheme.defaultTheme.propertyKeyTextStyle,
        keySearchHighlightTextStyle = keySearchHighlightTextStyle ??
            JsonExplorerTheme.defaultTheme.keySearchHighlightTextStyle,
        valueTextStyle =
            valueTextStyle ?? JsonExplorerTheme.defaultTheme.valueTextStyle,
        valueSearchHighlightTextStyle = valueSearchHighlightTextStyle ??
            JsonExplorerTheme.defaultTheme.valueSearchHighlightTextStyle,
        focusedKeySearchNodeHighlightTextStyle =
            focusedKeySearchHighlightTextStyle ??
                (keySearchHighlightTextStyle ??
                    JsonExplorerTheme
                        .defaultTheme.focusedKeySearchNodeHighlightTextStyle),
        focusedValueSearchHighlightTextStyle =
            focusedValueSearchHighlightTextStyle ??
                (valueSearchHighlightTextStyle ??
                    JsonExplorerTheme
                        .defaultTheme.focusedValueSearchHighlightTextStyle);

  const JsonExplorerTheme._({
    required this.rootKeyTextStyle,
    required this.propertyKeyTextStyle,
    required this.keySearchHighlightTextStyle,
    required this.valueTextStyle,
    required this.valueSearchHighlightTextStyle,
    required this.focusedKeySearchNodeHighlightTextStyle,
    required this.focusedValueSearchHighlightTextStyle,
    required this.indentationLineColor,
    required this.highlightColor,
    required this.indentationPadding,
    required this.propertyIndentationPaddingFactor,
  });

  /// Default theme used if no theme is set.
  static const defaultTheme = JsonExplorerTheme._(
    rootKeyTextStyle: TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    propertyKeyTextStyle: TextStyle(
      fontSize: 14,
      color: Colors.black54,
      fontWeight: FontWeight.bold,
    ),
    valueTextStyle: TextStyle(
      fontSize: 14,
      color: Colors.redAccent,
    ),
    keySearchHighlightTextStyle: TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.amberAccent,
    ),
    valueSearchHighlightTextStyle: TextStyle(
      fontSize: 14,
      color: Colors.redAccent,
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.amberAccent,
    ),
    focusedKeySearchNodeHighlightTextStyle: TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.lightGreen,
    ),
    focusedValueSearchHighlightTextStyle: TextStyle(
      fontSize: 14,
      color: Colors.redAccent,
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.lightGreen,
    ),
    indentationLineColor: Colors.grey,
    highlightColor: Colors.black12,
    indentationPadding: 8.0,
    propertyIndentationPaddingFactor: 4,
  );

  JsonExplorerTheme copyWith({
    TextStyle? rootKeyTextStyle,
    TextStyle? propertyKeyTextStyle,
    TextStyle? keySearchHighlightTextStyle,
    TextStyle? valueTextStyle,
    TextStyle? valueSearchHighlightTextStyle,
    TextStyle? focusedKeySearchNodeHighlightTextStyle,
    TextStyle? focusedValueSearchHighlightTextStyle,
    Color? indentationLineColor,
    Color? highlightColor,
    double? indentationPadding,
    double? propertyIndentationPaddingFactor,
  }) =>
      JsonExplorerTheme(
        rootKeyTextStyle: rootKeyTextStyle ?? this.rootKeyTextStyle,
        propertyKeyTextStyle: propertyKeyTextStyle ?? this.propertyKeyTextStyle,
        keySearchHighlightTextStyle:
            keySearchHighlightTextStyle ?? this.keySearchHighlightTextStyle,
        valueTextStyle: valueTextStyle ?? this.valueTextStyle,
        valueSearchHighlightTextStyle:
            valueSearchHighlightTextStyle ?? this.valueSearchHighlightTextStyle,
        indentationLineColor: indentationLineColor ?? this.indentationLineColor,
        highlightColor: highlightColor ?? this.highlightColor,
        indentationPadding: indentationPadding ?? this.indentationPadding,
        propertyIndentationPaddingFactor: propertyIndentationPaddingFactor ??
            this.propertyIndentationPaddingFactor,
        focusedKeySearchHighlightTextStyle:
            focusedKeySearchNodeHighlightTextStyle ??
                this.focusedKeySearchNodeHighlightTextStyle,
        focusedValueSearchHighlightTextStyle:
            focusedValueSearchHighlightTextStyle ??
                this.focusedValueSearchHighlightTextStyle,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is JsonExplorerTheme &&
        rootKeyTextStyle == other.rootKeyTextStyle &&
        propertyKeyTextStyle == other.propertyKeyTextStyle &&
        valueTextStyle == other.valueTextStyle &&
        indentationLineColor == other.indentationLineColor &&
        highlightColor == other.highlightColor &&
        indentationPadding == other.indentationPadding &&
        propertyIndentationPaddingFactor ==
            other.propertyIndentationPaddingFactor &&
        keySearchHighlightTextStyle == other.keySearchHighlightTextStyle &&
        valueSearchHighlightTextStyle == other.valueSearchHighlightTextStyle &&
        focusedKeySearchNodeHighlightTextStyle ==
            other.focusedKeySearchNodeHighlightTextStyle &&
        focusedValueSearchHighlightTextStyle ==
            other.focusedValueSearchHighlightTextStyle;
  }

  @override
  int get hashCode => Object.hash(
        rootKeyTextStyle,
        propertyKeyTextStyle,
        valueTextStyle,
        indentationLineColor,
        highlightColor,
        indentationPadding,
        propertyIndentationPaddingFactor,
        keySearchHighlightTextStyle,
        valueSearchHighlightTextStyle,
        focusedKeySearchNodeHighlightTextStyle,
        focusedValueSearchHighlightTextStyle,
      );
}
