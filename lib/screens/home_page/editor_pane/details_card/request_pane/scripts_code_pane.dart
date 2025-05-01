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
  @override
  Widget build(BuildContext context) {
    int _selectedTabIndex = 0;
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

    final tabs = ["Pre-Req", "Post-Res"];
    final content = [
      ScriptsEditorPane(
        controller: preReqCodeController,
      ),
      ScriptsEditorPane(
        controller: postResCodeController,
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < tabs.length; i++)
                ListTile(
                  dense: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  selectedTileColor: _selectedTabIndex == i
                      ? Theme.of(context).colorScheme.secondaryFixed
                      : Theme.of(context).colorScheme.surface,
                  title: Text(
                    tabs[i],
                    style: TextStyle(
                      fontSize: 12,
                      color: _selectedTabIndex == i
                          ? Theme.of(context)
                              .colorScheme
                              .onSecondaryFixedVariant
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  selected: _selectedTabIndex == i,
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = i;
                    });
                  },
                ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: Container(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            child: content[_selectedTabIndex],
          ),
        ),
      ],
    );
  }
}
