import 'package:flutter/material.dart';
import '../tokens/tokens.dart';
import 'decoration_input_textfield.dart';

class ADOutlinedTextField extends StatefulWidget {
  const ADOutlinedTextField({
    super.key,
    this.keyId,
    this.controller,
    this.readOnly = false,
    this.enabled,
    this.maxLines = 1,
    this.expands = false,
    this.initialValue,
    this.textStyle,
    this.textColor,
    this.textFontSize,
    this.hintText,
    this.hintTextStyle,
    this.hintTextColor,
    this.hintTextFontSize,
    this.contentPadding,
    this.fillColor,
    this.focussedBorderColor,
    this.enabledBorderColor,
    this.isDense,
    this.onChanged,
    this.colorScheme,
    this.onOverlayToggle,
  });

  final String? keyId;
  final TextEditingController? controller;
  final bool readOnly;
  final bool? enabled;
  final int? maxLines;
  final bool expands;
  final bool? isDense;
  final String? initialValue;
  final TextStyle? textStyle;
  final double? textFontSize;
  final Color? textColor;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final double? hintTextFontSize;
  final Color? hintTextColor;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Color? focussedBorderColor;
  final Color? enabledBorderColor;
  final void Function(String)? onChanged;
  final ColorScheme? colorScheme;
  final void Function(
    bool,
    GlobalKey,
    String,
    TextStyle,
    ColorScheme,
    FocusNode,
    TextEditingController,
    InputDecoration,
  )? onOverlayToggle;

  @override
  State<ADOutlinedTextField> createState() => _ADOutlinedTextFieldState();
}

class _ADOutlinedTextFieldState extends State<ADOutlinedTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isFocused = false;
  final GlobalKey _textFieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    _updateOverlay();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    widget.onOverlayToggle?.call(
      false,
      _textFieldKey,
      '',
      TextStyle(),
      Theme.of(context).colorScheme,
      _focusNode,
      _controller,
      InputDecoration(),
    );
    super.dispose();
  }

  int _calculateLineCount(String text, TextStyle textStyle, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter.computeLineMetrics().length;
  }

  void _updateOverlay() {
    var clrScheme = widget.colorScheme ?? Theme.of(context).colorScheme;
    final textStyle = widget.textStyle ??
        kCodeStyle.copyWith(
          fontSize: widget.textFontSize,
          color: widget.textColor ?? clrScheme.onSurface,
        );
    final contentPadding = widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8);
    final horizontalPadding = contentPadding is EdgeInsets ? contentPadding.horizontal : 16.0;

    final maxWidth = context.size!.width - horizontalPadding;
    final text = _controller.text.isEmpty ? widget.hintText ?? '' : _controller.text;
    final lineCount = _calculateLineCount(text, textStyle, maxWidth);
    final isMultiLine = lineCount > 1;
    final showOverlay = _isFocused && isMultiLine;

    final decoration = getTextFieldInputDecoration(
      clrScheme,
      fillColor: widget.fillColor,
      hintText: widget.hintText,
      hintTextStyle: widget.hintTextStyle,
      hintTextFontSize: widget.hintTextFontSize,
      hintTextColor: widget.hintTextColor,
      contentPadding: contentPadding,
      focussedBorderColor: widget.focussedBorderColor,
      enabledBorderColor: widget.enabledBorderColor,
      isDense: widget.isDense ?? true,
    );

    widget.onOverlayToggle?.call(
      showOverlay,
      _textFieldKey,
      text,
      textStyle,
      clrScheme,
      _focusNode,
      _controller,
      decoration,
    );
  }

  @override
  Widget build(BuildContext context) {
    var clrScheme = widget.colorScheme ?? Theme.of(context).colorScheme;
    final textStyle = widget.textStyle ??
        kCodeStyle.copyWith(
          fontSize: widget.textFontSize,
          color: widget.textColor ?? clrScheme.onSurface,
        );
    final contentPadding = widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8);

    return TextFormField(
      key: _textFieldKey,
      controller: _controller,
      focusNode: _focusNode,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLines: _isFocused ? null : 1,
      keyboardType: TextInputType.multiline,
      expands: widget.expands,
      style: textStyle,
      decoration: getTextFieldInputDecoration(
        clrScheme,
        fillColor: widget.fillColor,
        hintText: widget.hintText,
        hintTextStyle: widget.hintTextStyle,
        hintTextFontSize: widget.hintTextFontSize,
        hintTextColor: widget.hintTextColor,
        contentPadding: contentPadding,
        focussedBorderColor: widget.focussedBorderColor,
        enabledBorderColor: widget.enabledBorderColor,
        isDense: widget.isDense ?? true,
      ),
      onChanged: (value) {
        widget.onChanged?.call(value);
        setState(() {});
        _updateOverlay();
      },
    );
  }
}