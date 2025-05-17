import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/screens/dashflow/dashflow_builder/nodes.dart';

final mobileScaffoldKeyStateProvider =
    StateProvider<GlobalKey<ScaffoldState>>((ref) => kHomeScaffoldKey);
final leftDrawerStateProvider = StateProvider<bool>((ref) => false);
final navRailIndexStateProvider = StateProvider<int>((ref) => 0);
final selectedIdEditStateProvider = StateProvider<String?>((ref) => null);
final environmentFieldEditStateProvider = StateProvider<String?>((ref) => null);
final codePaneVisibleStateProvider = StateProvider<bool>((ref) => false);
final historyCodePaneVisibleStateProvider = StateProvider<bool>((ref) => false);
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

final collectionSearchQueryProvider = StateProvider<String>((ref) => '');
final environmentSearchQueryProvider = StateProvider<String>((ref) => '');
final importFormatStateProvider =
    StateProvider<ImportFormat>((ref) => ImportFormat.curl);
final userOnboardedProvider = StateProvider<bool>((ref) => false);

final workflowProvider = StateNotifierProvider<WorkflowNotifier, List<NodeData>>((ref) => WorkflowNotifier());
final hoverNodeProvider = StateProvider<int?>((ref) => null);
final connectionListProvider = StateProvider<List<Connection>>((ref) => []);
class WorkflowNotifier extends StateNotifier<List<NodeData>> {
  WorkflowNotifier() : super([
    NodeData(id: 1, offset: Offset(0, 0)),
    NodeData(id: 2, offset: Offset(50, 50)),
  ]);

    void updateNodeOffset(int id, Offset newOffset) {
    state = [
      for (final node in state)
        if (node.id == id) node.copyWith(offset: newOffset) else node,
    ];
  }

  void addNode(NodeData node) {
    state = [...state, node];
  }

  void updateNode(int id, {String? title, String? url, Map<String, String>? headers}) {
    state = [
      for (final node in state)
        if (node.id == id)
          node.copyWith(title: title, url: url, headers: headers)
        else
          node,
    ];
  }
}

class ConnectionListNotifier extends StateNotifier<List<Connection>> {
  ConnectionListNotifier() : super([]); // Initialize with an empty list

  void addConnection(Connection connection) {
    state = [...state, connection]; // Add a new connection
  }

  void removeConnection(Connection connection) {
    state = state.where((c) => c != connection).toList(); // Remove a connection
  }
}

