import 'package:apidash/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class EnvironmentsEditorPane extends ConsumerStatefulWidget {
  const EnvironmentsEditorPane({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnvironmentsCollectionsPaneState();
}

class _EnvironmentsCollectionsPaneState
    extends ConsumerState<EnvironmentsEditorPane> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kIsMacOS || kIsWindows ? kPt24o8 : kP8,
      child: Column(
        children: [
          Text(
            'Environments',
            style: Theme.of(context).textTheme.titleMedium,
          )
          // EditorPaneRequestURLCard(),
          // kVSpacer10,
          // Expanded(
          //   child: EditorPaneRequestDetailsCard(),
          // ),
        ],
      ),
    );
  }
}
