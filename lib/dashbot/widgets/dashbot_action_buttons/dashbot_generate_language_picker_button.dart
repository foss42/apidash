import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../dashbot_action.dart';

class DashbotGenerateLanguagePicker extends ConsumerWidget
    with DashbotActionMixin {
  @override
  final ChatAction action;
  const DashbotGenerateLanguagePicker({super.key, required this.action});

  List<String> _extractLanguages(dynamic value) {
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return const [
      'JavaScript (fetch)',
      'Python (requests)',
      'Dart (http)',
      'Go (net/http)',
      'cURL',
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ds = DesignSystemProvider.of(context);
    final langs = _extractLanguages(action.value);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final l in langs)
          OutlinedButton(
            onPressed: () {
              ref.read(chatViewmodelProvider.notifier).sendMessage(
                    text: 'Please generate code in $l',
                    type: ChatMessageType.generateCode,
                  );
            },
            child: Text(l, style: TextStyle(fontSize: 12*ds.scaleFactor)),
          ),
      ],
    );
  }
}
