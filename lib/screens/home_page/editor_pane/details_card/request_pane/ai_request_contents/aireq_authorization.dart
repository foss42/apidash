import 'package:apidash/widgets/editor.dart';
import 'package:flutter/material.dart';

class AIRequestAuthorizationSection extends StatelessWidget {
  const AIRequestAuthorizationSection({super.key});

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
                key: Key("aireq-authvalue-body"),
                fieldKey: "aireq-authvalue-body",
                onChanged: (String value) {
                  // ref
                  //     .read(collectionStateNotifierProvider.notifier)
                  //     .update(body: value);
                },
                hintText: 'Enter API key or Authorization Credentials',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
