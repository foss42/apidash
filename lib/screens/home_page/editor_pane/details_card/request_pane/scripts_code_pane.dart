import 'package:apidash/widgets/scripts_editor_pane.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/javascript.dart';

class ScriptsCodePane extends StatefulWidget {
  const ScriptsCodePane({super.key});

  @override
  State<ScriptsCodePane> createState() => _ScriptsCodePaneState();
}

class _ScriptsCodePaneState extends State<ScriptsCodePane> {
  int _selectedTabIndex = 0;
  final preReqCodeController = CodeController(
    text: '// Use javascript to modify this request dynamically',
    language: javascript,
  );
  final postResCodeController = CodeController(
    text: '...',
    language: javascript,
  );

  @override
  Widget build(BuildContext context) {
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
