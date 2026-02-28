import 'package:apidash/widgets/button_copy.dart';
import 'package:apidash/widgets/previewer_code.dart';
import 'package:apidash/widgets/widget_sending.dart';
import 'package:apidash_design_system/tokens/tokens.dart';
import 'package:flutter/material.dart';

class GeneratedToolCodeCopyPage extends StatelessWidget {
  final String? toolCode;
  final String language;
  const GeneratedToolCodeCopyPage(
      {super.key, required this.toolCode, required this.language});

  @override
  Widget build(BuildContext context) {
    final lightMode = Theme.of(context).brightness == Brightness.light;
    var codeTheme = lightMode ? kLightCodeTheme : kDarkCodeTheme;

    if (toolCode == null) {
      return SendingWidget(
        startSendingTime: DateTime.now(),
        showTimeElapsed: false,
      );
    }

    if (toolCode!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(right: 40),
        child: Center(
          child: Icon(
            Icons.token_outlined,
            color: lightMode ? Colors.black12 : Colors.white12,
            size: 500,
          ),
        ),
      );
    }

    return Container(
      color: const Color.fromARGB(26, 123, 123, 123),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CopyButton(
            toCopy: toolCode!,
            showLabel: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: CodePreviewer(
                  code: toolCode!,
                  theme: codeTheme,
                  language: language.toLowerCase(),
                  textStyle: kCodeStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
