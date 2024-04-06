import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navRailIndexStateProvider = StateProvider<int>((ref) => 0);
final selectedIdEditStateProvider = StateProvider<String?>((ref) => null);
final codePaneVisibleStateProvider = StateProvider<bool>((ref) => false);
final saveDataStateProvider = StateProvider<bool>((ref) => false);
final clearDataStateProvider = StateProvider<bool>((ref) => false);
final hasUnsavedChangesProvider = StateProvider<bool>((ref) => false);

// final nameTextFieldControllerProvider =
//     StateProvider.autoDispose<TextEditingController>((ref) {
//   TextEditingController controller = TextEditingController(text: "");
//   ref.onDispose(() {
//     controller.dispose();
//   });
//   return controller;
// });

final nameTextFieldFocusNodeProvider =
    StateProvider.autoDispose<FocusNode>((ref) {
  FocusNode focusNode = FocusNode();
  ref.onDispose(() {
    focusNode.dispose();
  });
  return focusNode;
});

final searchQueryProvider = StateProvider<String>((ref) => '');
