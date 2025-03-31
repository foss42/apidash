import 'dart:math' as math;
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_text_field/json_text_field.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';

class JsonTextFieldEditor extends StatefulWidget {
  const JsonTextFieldEditor({
    super.key,
    required this.fieldKey,
    this.onChanged,
    this.initialValue,
    this.hintText,
    this.readOnly = false,
    this.minHeight,
  });

  final String fieldKey;
  final Function(String)? onChanged;
  final String? initialValue;
  final String? hintText;
  final bool readOnly;
  final double? minHeight;
  
  @override
  State<JsonTextFieldEditor> createState() => _JsonTextFieldEditorState();
}

class _JsonTextFieldEditorState extends State<JsonTextFieldEditor> with AutomaticKeepAliveClientMixin {
  late final JsonTextFieldController controller;
  late final FocusNode editorFocusNode;
  bool _isDisposed = false;
  bool _isSuggestionsVisible = false;
  final ScrollController _scrollController = ScrollController();
  double _contentHeight = 0;

  void insertTab() {
    if (_isDisposed) return;
    
    try {
      String sp = "  ";
      int offset = math.min(
          controller.selection.baseOffset, controller.selection.extentOffset);
      if (offset < 0) offset = 0;
      
      String text = controller.text.substring(0, offset) +
          sp +
          controller.text.substring(offset);
      controller.value = TextEditingValue(
        text: text,
        selection: controller.selection.copyWith(
          baseOffset: controller.selection.baseOffset + sp.length,
          extentOffset: controller.selection.extentOffset + sp.length,
        ),
      );
      widget.onChanged?.call(text);
    } catch (e) {
      debugPrint('Error inserting tab: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    controller = JsonTextFieldController();
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
    try {
      controller.formatJson(sortJson: false);
    } catch (e) {
      debugPrint('Error formatting JSON: $e');
    }
    editorFocusNode = FocusNode(debugLabel: "Editor Focus Node");
    
    controller.addListener(_updateContentHeight);
  }
  
  void _updateContentHeight() {
    if (_isDisposed || !mounted) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isDisposed || !mounted) return;
      
      try {
        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: controller.text,
            style: kCodeStyle.copyWith(
              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
            ),
          ),
          textDirection: TextDirection.ltr,
          maxLines: null,
        );
        
        textPainter.layout(maxWidth: MediaQuery.of(context).size.width * 0.8);
        
        final double newHeight = math.max(
          widget.minHeight ?? 100, 
          textPainter.height + 40
        );
        
        if (_contentHeight != newHeight) {
          setState(() {
            _contentHeight = newHeight;
          });
        }
      } catch (e) {
        debugPrint('Error updating content height: $e');
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    editorFocusNode.dispose();
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(JsonTextFieldEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDisposed && oldWidget.initialValue != widget.initialValue) {
      try {
        controller.text = widget.initialValue ?? "";
        controller.selection = TextSelection.collapsed(offset: controller.text.length);
        _updateContentHeight();
      } catch (e) {
        debugPrint('Error updating widget: $e');
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Stack(
      children: [
        CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            const SingleActivator(LogicalKeyboardKey.tab): () {
              insertTab();
            },
          },
          child: MultiTriggerAutocomplete(
            key: ValueKey("${widget.fieldKey}-autocomplete"),
            textEditingController: controller,
            focusNode: editorFocusNode,
            autocompleteTriggers: [
              AutocompleteTrigger(
                trigger: '{',
                triggerEnd: "}}",
                triggerOnlyAfterSpace: false,
                optionsViewBuilder: (context, autocompleteQuery, controller) {
                  if (!_isSuggestionsVisible) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!_isDisposed && mounted) {
                        setState(() {
                          _isSuggestionsVisible = true;
                        });
                      }
                    });
                  }
                  
                  return EnvironmentTriggerOptions(
                    query: autocompleteQuery.query,
                    onSuggestionTap: (suggestion) {
                      if (_isDisposed) return;
                      try {
                        final autocomplete = MultiTriggerAutocomplete.of(context);
                        autocomplete.acceptAutocompleteOption(
                          '{${suggestion.variable.key}',
                        );
                        
                        if (_isSuggestionsVisible && mounted) {
                          setState(() {
                            _isSuggestionsVisible = false;
                          });
                        }
                        
                        widget.onChanged?.call(controller.text);
                      } catch (e) {
                        debugPrint('Error handling suggestion tap: $e');
                      }
                    },
                  );
                },
              ),
              AutocompleteTrigger(
                trigger: '{{',
                triggerEnd: "}}",
                triggerOnlyAfterSpace: false,
                optionsViewBuilder: (context, autocompleteQuery, controller) {
                  if (!_isSuggestionsVisible) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!_isDisposed && mounted) {
                        setState(() {
                          _isSuggestionsVisible = true;
                        });
                      }
                    });
                  }
                  
                  return EnvironmentTriggerOptions(
                    query: autocompleteQuery.query,
                    onSuggestionTap: (suggestion) {
                      if (_isDisposed) return;
                      try {
                        final autocomplete = MultiTriggerAutocomplete.of(context);
                        autocomplete.acceptAutocompleteOption(
                          suggestion.variable.key,
                        );
                        
                        if (_isSuggestionsVisible && mounted) {
                          setState(() {
                            _isSuggestionsVisible = false;
                          });
                        }
                        
                        widget.onChanged?.call(controller.text);
                      } catch (e) {
                        debugPrint('Error handling suggestion tap: $e');
                      }
                    },
                  );
                },
              ),
            ],
            fieldViewBuilder: (context, textEditingController, focusNode) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final double suggestionsHeight = _isSuggestionsVisible 
                      ? constraints.maxHeight / 2 
                      : constraints.maxHeight;
                      
                  final double fieldHeight = _contentHeight > 0 
                      ? math.min(_contentHeight, suggestionsHeight) 
                      : suggestionsHeight;
                      
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: SizedBox(
                      height: fieldHeight,
                      child: JsonTextField(
                        commonTextStyle: kCodeStyle.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kDarkCodeTheme['root']?.color
                              : kLightCodeTheme['root']?.color,
                        ),
                        specialCharHighlightStyle: kCodeStyle.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kDarkCodeTheme['root']?.color
                              : kLightCodeTheme['root']?.color,
                        ),
                        stringHighlightStyle: kCodeStyle.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kDarkCodeTheme['string']?.color
                              : kLightCodeTheme['string']?.color,
                        ),
                        numberHighlightStyle: kCodeStyle.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kDarkCodeTheme['number']?.color
                              : kLightCodeTheme['number']?.color,
                        ),
                        boolHighlightStyle: kCodeStyle.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kDarkCodeTheme['literal']?.color
                              : kLightCodeTheme['literal']?.color,
                        ),
                        nullHighlightStyle: kCodeStyle.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kDarkCodeTheme['variable']?.color
                              : kLightCodeTheme['variable']?.color,
                        ),
                        keyHighlightStyle: kCodeStyle.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kDarkCodeTheme['attr']?.color
                              : kLightCodeTheme['attr']?.color,
                          fontWeight: FontWeight.bold,
                        ),
                        isFormatting: true,
                        controller: controller,
                        focusNode: focusNode,
                        keyboardType: TextInputType.multiline,
                        expands: true,
                        maxLines: null,
                        readOnly: widget.readOnly,
                        style: kCodeStyle.copyWith(
                          fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                        ),
                        textAlignVertical: TextAlignVertical.top,
                        onChanged: (value) {
                          if (!_isDisposed) {
                            widget.onChanged?.call(value);
                            _updateContentHeight();
                          }
                        },
                        onTapOutside: (PointerDownEvent event) {
                          if (!_isDisposed && focusNode.hasFocus) {
                            focusNode.unfocus();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: widget.hintText ?? kHintContent,
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: kBorderRadius8,
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outlineVariant,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: kBorderRadius8,
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            ),
                          ),
                          filled: true,
                          hoverColor: kColorTransparent,
                          fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: ADIconButton(
            icon: Icons.format_align_left,
            tooltip: "Format JSON",
            onPressed: () {
              if (_isDisposed) return;
              try {
                controller.formatJson(sortJson: false);
                widget.onChanged?.call(controller.text);
                _updateContentHeight();
              } catch (e) {
                debugPrint('Error formatting JSON: $e');
              }
            },
          ),
        ),
      ],
    );
  }
}
