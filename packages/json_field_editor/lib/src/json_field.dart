import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:json_field_editor/json_field_editor.dart';
import 'package:json_field_editor/src/error_message_container.dart';
import 'package:json_field_editor/src/json_highlight/json_highlight.dart';
import 'package:json_field_editor/src/json_utils.dart';

class JsonField extends ExtendedTextField {
  @override
  Type get runtimeType => EditableText;

  const JsonField({
    super.key,
    this.fieldKey,
    super.autocorrect,
    super.autofillHints,
    super.autofocus,
    super.buildCounter,
    super.canRequestFocus,
    super.clipBehavior,
    this.controller,
    super.cursorColor,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorWidth,
    super.decoration,
    super.enableInteractiveSelection,
    super.enableSuggestions,
    super.expands,
    super.focusNode,
    super.inputFormatters,
    super.keyboardAppearance,
    super.keyboardType,
    super.maxLength,
    super.maxLines,
    super.minLines,
    super.obscureText,
    super.onAppPrivateCommand,
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.onTap,
    super.readOnly,
    super.scrollController,
    super.scrollPadding,
    super.scrollPhysics,
    super.showCursor,
    super.smartDashesType,
    super.smartQuotesType,
    super.style,
    super.textAlign,
    super.textAlignVertical,
    super.textCapitalization,
    super.textDirection,
    super.textInputAction,
    super.toolbarOptions,
    super.contentInsertionConfiguration,
    super.selectionControls,
    super.mouseCursor,
    super.dragStartBehavior,
    super.cursorOpacityAnimates,
    super.enableIMEPersonalizedLearning,
    super.enabled,
    super.extendedContextMenuBuilder,
    super.extendedSpellCheckConfiguration,
    super.maxLengthEnforcement,
    super.obscuringCharacter,
    super.onTapOutside,
    super.restorationId,
    super.scribbleEnabled,
    super.selectionHeightStyle,
    super.selectionWidthStyle,
    super.strutStyle,
    super.undoController,
    this.keyHighlightStyle,
    this.stringHighlightStyle,
    this.numberHighlightStyle,
    this.boolHighlightStyle,
    this.nullHighlightStyle,
    this.specialCharHighlightStyle,
    this.errorTextStyle,
    this.commonTextStyle,
    this.errorContainerDecoration,
    this.showErrorMessage = false,
    this.isFormatting = true,
    this.doInitFormatting = false,
    this.onError,
  });

  /// If true, the text will be formatted as json. If false, the text field will behave as a normal text field. Default is true.
  final bool isFormatting;

  /// If true, the text will be formatted during initialization
  final bool doInitFormatting;

  /// Provide the key value for ExtendedTextField widget
  final String? fieldKey;

  /// TextStyle for the json key.
  final TextStyle? keyHighlightStyle;

  /// TextStyle for the json string.
  final TextStyle? stringHighlightStyle;

  /// TextStyle for the json number.
  final TextStyle? numberHighlightStyle;

  /// TextStyle for the json bool.
  final TextStyle? boolHighlightStyle;

  /// TextStyle for the json null.
  final TextStyle? nullHighlightStyle;

  /// TextStyle for the json special character.
  final TextStyle? specialCharHighlightStyle;

  /// TextStyle for the error message.
  final TextStyle? errorTextStyle;

  /// TextStyle for the common text.
  final TextStyle? commonTextStyle;

  /// If true, the error message will be shown, at bottom of the text field. Default is false.
  final bool showErrorMessage;

  /// Decoration for the error message container.
  final BoxDecoration? errorContainerDecoration;

  /// Callback for the error message.
  final Function(String?)? onError;
  @override
  final JsonTextFieldController? controller;

  @override
  JsonFieldState createState() {
    return JsonFieldState();
  }
}

class JsonFieldState extends State<JsonField> {
  late final JsonTextFieldController controller =
      widget.controller ?? JsonTextFieldController();
  late String? jsonError =
      controller.text.isEmpty
          ? null
          : JsonUtils.getJsonParsingError(controller.text);
  late TextStyle style = widget.style ?? const TextStyle();
  late final TextStyle keyHighlightStyle =
      widget.keyHighlightStyle ??
      style.copyWith(
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 68, 143, 255),
      );
  late final TextStyle stringHighlightStyle =
      widget.stringHighlightStyle ?? style.copyWith(color: Colors.green[900]);
  late final TextStyle numberHighlightStyle =
      widget.numberHighlightStyle ?? style.copyWith(color: Colors.purple[900]);
  late final TextStyle boolHighlightStyle =
      widget.boolHighlightStyle ??
      style.copyWith(color: Colors.purple[900], fontWeight: FontWeight.bold);
  late final TextStyle nullHighlightStyle =
      widget.nullHighlightStyle ??
      style.copyWith(color: Colors.grey[600], fontWeight: FontWeight.bold);
  late final TextStyle specialCharHighlightStyle =
      widget.specialCharHighlightStyle ??
      style.copyWith(color: Colors.grey[700]);
  late final TextStyle errorTextStyle =
      widget.errorTextStyle ?? style.copyWith(color: Colors.red);
  late final TextStyle commonTextStyle =
      widget.commonTextStyle ?? style.copyWith(color: Colors.black);

  @override
  void initState() {
    controller.text =
        (widget.doInitFormatting &&
                widget.isFormatting &&
                JsonUtils.isValidJson(controller.text))
            ? JsonUtils.getPrettyPrintJson(controller.text)
            : controller.text;

    super.initState();
  }

  void _setJsonError(String? error) => setState(() => jsonError = error);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        ExtendedTextField(
          key: widget.fieldKey != null ? ValueKey(widget.fieldKey!) : null,
          autocorrect: widget.autocorrect,
          autofillHints: widget.autofillHints,
          autofocus: widget.autofocus,
          buildCounter: widget.buildCounter,
          canRequestFocus: widget.canRequestFocus,
          clipBehavior: widget.clipBehavior,
          controller: controller,
          cursorColor: widget.cursorColor,
          cursorHeight: widget.cursorHeight,
          cursorRadius: widget.cursorRadius,
          cursorWidth: widget.cursorWidth,
          decoration: widget.decoration,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          enableSuggestions: widget.enableSuggestions,
          expands: widget.expands,
          focusNode: widget.focusNode,
          inputFormatters: widget.inputFormatters,
          keyboardAppearance: widget.keyboardAppearance,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          obscureText: widget.obscureText,
          onAppPrivateCommand: widget.onAppPrivateCommand,
          onChanged: (value) {
            widget.onChanged?.call(value);
            if (widget.isFormatting) {
              JsonUtils.validateJson(
                json: value,
                onError: (error) {
                  _setJsonError(error);
                  widget.onError?.call(error);
                },
              );
            }
          },
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          scrollController: widget.scrollController,
          scrollPadding: widget.scrollPadding,
          scrollPhysics: widget.scrollPhysics,
          showCursor: widget.showCursor,
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
          specialTextSpanBuilder: JsonHighlight(
            boolHighlightStyle: boolHighlightStyle,
            keyHighlightStyle: keyHighlightStyle,
            nullHighlightStyle: nullHighlightStyle,
            numberHighlightStyle: numberHighlightStyle,
            specialCharHighlightStyle: stringHighlightStyle,
            stringHighlightStyle: stringHighlightStyle,
            commonTextStyle: commonTextStyle,
            isFormating: widget.isFormatting,
          ),
          style: widget.style,
          textAlign: widget.textAlign,
          textAlignVertical: widget.textAlignVertical,
          textCapitalization: widget.textCapitalization,
          textDirection: widget.textDirection,
          textInputAction: widget.textInputAction,
          contentInsertionConfiguration: widget.contentInsertionConfiguration,
          selectionControls: widget.selectionControls,
          mouseCursor: widget.mouseCursor,
          dragStartBehavior: widget.dragStartBehavior,
          cursorOpacityAnimates: widget.cursorOpacityAnimates,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          enabled: widget.enabled,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          obscuringCharacter: widget.obscuringCharacter,
          onTapOutside: widget.onTapOutside,
          restorationId: widget.restorationId,
          scribbleEnabled: widget.scribbleEnabled,
          selectionHeightStyle: widget.selectionHeightStyle,
          selectionWidthStyle: widget.selectionWidthStyle,
          strutStyle: widget.strutStyle,
          undoController: widget.undoController,
        ),
        if (widget.isFormatting && widget.showErrorMessage)
          ErrorMessageContainer(
            jsonError: jsonError,
            errorTextStyle: errorTextStyle,
            decoration:
                widget.errorContainerDecoration ??
                const BoxDecoration(color: Colors.amber),
          ),
      ],
    );
  }
}
