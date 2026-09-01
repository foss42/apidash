import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final mobileScaffoldKeyStateProvider = StateProvider<GlobalKey<ScaffoldState>>(
  (ref) => kHomeScaffoldKey,
);
final leftDrawerStateProvider = StateProvider<bool>((ref) => false);
final navRailIndexStateProvider = StateProvider<int>((ref) => 0);
const kSettingsNavRailIndex = 4;
final openAiLlmSetupProvider = StateProvider<bool>((ref) => false);

void openAddLlmInSettings(WidgetRef ref) {
  ref.read(openAiLlmSetupProvider.notifier).state = true;
  ref.read(navRailIndexStateProvider.notifier).state = kSettingsNavRailIndex;
}

final selectedIdEditStateProvider = StateProvider<String?>((ref) => null);
final environmentFieldEditStateProvider = StateProvider<String?>((ref) => null);
final codePaneVisibleStateProvider = StateProvider<bool>((ref) => false);
final historyCodePaneVisibleStateProvider = StateProvider<bool>((ref) => false);
final saveDataStateProvider = StateProvider<bool>((ref) => false);
final clearDataStateProvider = StateProvider<bool>((ref) => false);
final hasUnsavedChangesProvider = StateProvider<bool>((ref) => false);
final showTerminalBadgeProvider = StateProvider<bool>((ref) => false);

// final nameTextFieldControllerProvider =
//     StateProvider.autoDispose<TextEditingController>((ref) {
//   TextEditingController controller = TextEditingController(text: "");
//   ref.onDispose(() {
//     controller.dispose();
//   });
//   return controller;
// });

final nameTextFieldFocusNodeProvider = StateProvider.autoDispose<FocusNode>((
  ref,
) {
  FocusNode focusNode = FocusNode();
  ref.onDispose(() {
    focusNode.dispose();
  });
  return focusNode;
});

final collectionSearchQueryProvider = StateProvider<String>((ref) => '');
final environmentSearchQueryProvider = StateProvider<String>((ref) => '');
final importFormatStateProvider = StateProvider<ImportFormat>(
  (ref) => ImportFormat.curl,
);
final userOnboardedProvider = StateProvider<bool>((ref) => false);

final dashbotShowMobileProvider = StateProvider<bool>((ref) => false);
