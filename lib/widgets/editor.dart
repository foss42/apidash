import 'dart:math' as math;
import 'package:apidash/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';

class TextFieldEditor extends StatefulWidget {
  const TextFieldEditor({
    super.key,
    required this.fieldKey,
    this.onChanged,
    this.initialValue,
    this.readOnly = false,
    this.hintText,
    this.minHeight,
  });

  final String fieldKey;
  final Function(String)? onChanged;
  final String? initialValue;
  final bool readOnly;
  final String? hintText;
  final double? minHeight;
  
  @override
  State<TextFieldEditor> createState() => _TextFieldEditorState();
}

class _TextFieldEditorState extends State<TextFieldEditor> {
  final TextEditingController controller = TextEditingController();
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
  void initState() {
    super.initState();
    editorFocusNode = FocusNode(debugLabel: "Editor Focus Node");
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
    
    controller.addListener(_updateContentHeight);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isDisposed || !mounted) return;
      _updateContentHeight();
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (editorFocusNode.hasPrimaryFocus) {
      editorFocusNode.unfocus();
    }
    editorFocusNode.dispose();
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TextFieldEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDisposed && oldWidget.initialValue != widget.initialValue && widget.initialValue != null) {
      controller.text = widget.initialValue!;
      try {
        controller.selection = TextSelection.collapsed(offset: controller.text.length);
      } catch (e) {
        debugPrint('Error setting text selection: $e');
      }
      _updateContentHeight();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  if (!_isDisposed && mounted) {
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
                  if (!_isDisposed && mounted) {
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
                      child: TextFormField(
                        key: Key(widget.fieldKey),
                        controller: controller,
                        focusNode: editorFocusNode,
                        keyboardType: TextInputType.multiline,
                        expands: true,
                        maxLines: null,
                        readOnly: widget.readOnly,
                        style: kCodeStyle.copyWith(
                          fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                        ),
                        textAlignVertical: TextAlignVertical.top,
                        onChanged: (value) {
                          widget.onChanged?.call(value);
                          _updateContentHeight();
                        },
                        onTapOutside: (PointerDownEvent event) {
                          if (!_isDisposed && editorFocusNode.hasFocus) {
                            editorFocusNode.unfocus();
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
      ],
    );
  }
}