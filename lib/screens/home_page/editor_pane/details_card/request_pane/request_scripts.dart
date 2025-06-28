import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class EditRequestScripts extends ConsumerStatefulWidget {
  const EditRequestScripts({super.key});

  @override
  ConsumerState<EditRequestScripts> createState() => _EditRequestScriptsState();
}

class _EditRequestScriptsState extends ConsumerState<EditRequestScripts> {
  int _selectedTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    final requestModel = ref.read(selectedRequestModelProvider);
    final isDarkMode =
        ref.watch(settingsProvider.select((value) => value.isDark));
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
      CodeEditor(
        controller: preReqCodeController,
        isDark: isDarkMode,
      ),
      CodeEditor(
        controller: postResCodeController,
        isDark: isDarkMode,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: kPh8b6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ADDropdownButton<int>(
                isDense: true,
                iconSize: kButtonIconSizeMedium,
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
              LearnButton(
                url: kLearnScriptingUrl,
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: kPt5o10,
            child: content[_selectedTabIndex],
          ),
        ),
      ],
    );
  }
}
