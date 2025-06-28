import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';

class HistoryScriptsTab extends ConsumerStatefulWidget {
  const HistoryScriptsTab({super.key});

  @override
  ConsumerState<HistoryScriptsTab> createState() => _ScriptsCodePaneState();
}

class _ScriptsCodePaneState extends ConsumerState<HistoryScriptsTab> {
  int _selectedTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    final hisRequestModel = ref.read(selectedHistoryRequestModelProvider);
    final isDarkMode =
        ref.watch(settingsProvider.select((value) => value.isDark));
    final preReqCodeController = CodeController(
      text: hisRequestModel?.preRequestScript,
      language: javascript,
    );

    final postResCodeController = CodeController(
      text: hisRequestModel?.postRequestScript,
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
      CodeEditor(
        controller: preReqCodeController,
        readOnly: true,
        isDark: isDarkMode,
      ),
      CodeEditor(
        controller: postResCodeController,
        readOnly: true,
        isDark: isDarkMode,
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
