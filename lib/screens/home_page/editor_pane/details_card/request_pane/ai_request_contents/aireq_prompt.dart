import 'package:apidash/widgets/editor.dart';
import 'package:flutter/material.dart';

class AIRequestPromptSection extends StatelessWidget {
  const AIRequestPromptSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFieldEditor(
                key: Key("aireq-sysprompt-body"),
                fieldKey: "aireq-sysprompt-body",
                onChanged: (String value) {
                  // ref
                  //     .read(collectionStateNotifierProvider.notifier)
                  //     .update(body: value);
                },
                hintText: 'Enter System Prompt',
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFieldEditor(
                key: Key("aireq-userprompt-body"),
                fieldKey: "aireq-userprompt-body",
                onChanged: (String value) {
                  // ref
                  //     .read(collectionStateNotifierProvider.notifier)
                  //     .update(body: value);
                },
                hintText: 'Enter User Prompt',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
