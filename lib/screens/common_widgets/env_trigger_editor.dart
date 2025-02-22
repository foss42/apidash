// import 'package:flutter/material.dart';
// import 'package:multi_trigger_autocomplete_plus/multi_trigger_autocomplete_plus.dart';
// import 'package:extended_text_field/extended_text_field.dart';
// import 'env_regexp_span_builder.dart';
// import 'env_trigger_options.dart';
// import 'package:apidash_design_system/apidash_design_system.dart';
//
// class EnvironmentTriggerEditor extends StatefulWidget {
//   const EnvironmentTriggerEditor({
//     super.key,
//     required this.keyId,
//     this.hintText,
//     this.initialValue,
//     this.onChanged,
//     this.onFieldSubmitted,
//     this.style,
//     this.decoration,
//     this.optionsWidthFactor,
//   });
//
//   final String keyId;
//   final String? hintText;
//   final String? initialValue;
//   final void Function(String)? onChanged;
//   final void Function(String)? onFieldSubmitted;
//   final TextStyle? style;
//   final InputDecoration? decoration;
//   final double? optionsWidthFactor;
//
//   @override
//   State<EnvironmentTriggerEditor> createState() => _EnvironmentTriggerEditorState();
// }
//
// class _EnvironmentTriggerEditorState extends State<EnvironmentTriggerEditor> {
//   final TextEditingController controller = TextEditingController();
//   final FocusNode focusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     controller.text = widget.initialValue ?? '';
//     controller.selection =
//         TextSelection.collapsed(offset: controller.text.length);
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     focusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didUpdateWidget(EnvironmentTriggerEditor oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if ((oldWidget.keyId != widget.keyId) ||
//         (oldWidget.initialValue != widget.initialValue)) {
//       controller.text = widget.initialValue ?? "";
//       controller.selection =
//           TextSelection.collapsed(offset: controller.text.length);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiTriggerAutocomplete(
//       key: Key(widget.keyId),
//       textEditingController: controller,
//       focusNode: focusNode,
//       optionsWidthFactor: widget.optionsWidthFactor,
//       autocompleteTriggers: [
//         AutocompleteTrigger(
//             trigger: '{',
//             triggerEnd: "}}",
//             triggerOnlyAfterSpace: false,
//             optionsViewBuilder: (context, autocompleteQuery, controller) {
//               return EnvironmentTriggerOptions(
//                   query: autocompleteQuery.query,
//                   onSuggestionTap: (suggestion) {
//                     final autocomplete = MultiTriggerAutocomplete.of(context);
//                     autocomplete.acceptAutocompleteOption(
//                       '{${suggestion.variable.key}',
//                     );
//                     widget.onChanged?.call(controller.text);
//                   });
//             }),
//         AutocompleteTrigger(
//             trigger: '{{',
//             triggerEnd: "}}",
//             triggerOnlyAfterSpace: false,
//             optionsViewBuilder: (context, autocompleteQuery, controller) {
//               return EnvironmentTriggerOptions(
//                   query: autocompleteQuery.query,
//                   onSuggestionTap: (suggestion) {
//                     final autocomplete = MultiTriggerAutocomplete.of(context);
//                     autocomplete.acceptAutocompleteOption(
//                       suggestion.variable.key,
//                     );
//                     widget.onChanged?.call(controller.text);
//                   });
//             }),
//       ],
//       fieldViewBuilder: (context, textEditingController, focusnode) {
//         return ExtendedTextField(
//           controller: textEditingController,
//           focusNode: focusnode,
//           decoration:InputDecoration(
//                 hintText: widget.hintText,
//                 border: OutlineInputBorder(
//                 borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.outlineVariant, // Correct border color
//                 ),
//                 borderRadius: kBorderRadius8, // Use BorderRadius.circular(8.0) if kBorderRadius8 is a constant
//                 ),
//               ),
//           style: widget.style ??
//               const TextStyle(
//                 fontSize: 14,
//                 fontFamily: 'monospace',
//               ),
//           maxLines: null, // Allows multiple lines for text editing
//           expands: true, // Expands within parent container
//           keyboardType: TextInputType.multiline,
//           textAlignVertical: TextAlignVertical.top, // Aligns text cursor to the top
//           textAlign: TextAlign.left,
//           onChanged: widget.onChanged,
//           onSubmitted: widget.onFieldSubmitted,
//           specialTextSpanBuilder: EnvRegExpSpanBuilder(),
//           onTapOutside: (event) {
//             focusNode.unfocus();
//           },
//         );
//       },
//     );
//   }
// }
