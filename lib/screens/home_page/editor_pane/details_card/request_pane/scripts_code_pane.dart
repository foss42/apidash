import 'package:apidash/widgets/scripts_editor_pane.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:apidash/providers/providers.dart';

class ScriptsCodePane extends ConsumerStatefulWidget {
  const ScriptsCodePane({super.key});

  @override
  ConsumerState<ScriptsCodePane> createState() => _ScriptsCodePaneState();
}

class _ScriptsCodePaneState extends ConsumerState<ScriptsCodePane> {
  int _selectedTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    final requestModel = ref.read(selectedRequestModelProvider);

    final preReqCodeController = CodeController(
      text: requestModel?.preRequestScript,
      language: javascript,
    );

    final postResCodeController = CodeController(
      text: requestModel?.postRequestScript,
      language: javascript,
    );

    preReqCodeController.addListener(() {
      ref.read(collectionStateNotifierProvider.notifier).update(
            preRequestScript: preReqCodeController.text,
          );
    });

    postResCodeController.addListener(() {
      ref.read(collectionStateNotifierProvider.notifier).update(
            postRequestScript: postResCodeController.text,
          );
    });

    final tabs = [(0, "Pre Request"), (1, "Post Response")];
    final content = [
      ScriptsEditorPane(
        controller: preReqCodeController,
      ),
      ScriptsEditorPane(
        controller: postResCodeController,
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ADDropdownButton<int>(
            value: _selectedTabIndex,
            values: tabs,
            onChanged: (int? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedTabIndex = newValue;
                });
              }
            },
          ),
        ),
        Expanded(
          child: content[_selectedTabIndex],
        ),
      ],
    );
  }
}
