import 'package:apidash/widgets/scripts_editor_pane.dart';
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

    final tabs = ["Pre Request", "Post Response"];
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
          child: DropdownButton<int>(
            focusColor: Theme.of(context).colorScheme.surface,
            icon: Icon(
              Icons.arrow_drop_down_rounded,
              size: 22,
            ),
            borderRadius: BorderRadius.circular(9),
            elevation: 4,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
            underline: Container(
              height: 0,
            ),
            value: _selectedTabIndex,
            items: tabs.asMap().entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
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
