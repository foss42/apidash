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

  @override
  State<ADOutlinedTextField> createState() => _ADOutlinedTextFieldState();
}

class _ADOutlinedTextFieldState extends State<ADOutlinedTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isFocused = false;

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
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
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

  @override
  Widget build(BuildContext context) {
    var clrScheme = widget.colorScheme ?? Theme.of(context).colorScheme;
    final textStyle = widget.textStyle ??
        kCodeStyle.copyWith(
          fontSize: widget.textFontSize,
          color: widget.textColor ?? clrScheme.onSurface,
        );
    final contentPadding = widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8);
    final horizontalPadding = contentPadding is EdgeInsets ? contentPadding.horizontal : 16.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth - horizontalPadding;
        final text = _controller.text.isEmpty ? widget.hintText ?? '' : _controller.text;
        final lineCount = _calculateLineCount(text, textStyle, maxWidth);
        final isMultiLine = lineCount > 1;
        final showOverlayBox = _isFocused && isMultiLine;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            TextFormField(
              key: widget.keyId != null ? Key(widget.keyId!) : null,
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
                setState(() {}); // Trigger rebuild to update line count
              },
            ),
            if (showOverlayBox)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: clrScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: widget.focussedBorderColor ?? clrScheme.primary,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        _controller.text.isEmpty ? widget.hintText ?? '' : _controller.text,
                        style: textStyle.copyWith(
                          color: _controller.text.isEmpty
                              ? (widget.hintTextColor ?? clrScheme.onSurface.withOpacity(0.6))
                              : (widget.textColor ?? clrScheme.onSurface),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}