import 'package:apidash/providers/settings_providers.dart';
import 'package:apidash/screens/common_widgets/ai/ai_model_selector_button.dart';
import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToolRequirementSelectorPage extends StatefulWidget {
  final Function(String agent, String lang) onGenerateCallback;
  const ToolRequirementSelectorPage(
      {super.key, required this.onGenerateCallback});

  @override
  State<ToolRequirementSelectorPage> createState() =>
      _ToolRequirementSelectorPageState();
}

class _ToolRequirementSelectorPageState
    extends State<ToolRequirementSelectorPage> {
  String targetLanguage = 'PYTHON';
  String agentFramework = 'GEMINI';

  Map frameworkMapping = {
    'GEMINI': 'Gemini',
    'OPENAI': 'OpenAI',
    'LANGCHAIN': 'LangChain',
    'MICROSOFT_AUTOGEN': 'Microsoft AutoGen',
    'MISTRAL': 'Mistral',
    'ANTRHOPIC': 'Anthropic',
  };

  Map languageMapping = {
    'PYTHON': 'Python 3',
    'JAVASCRIPT': 'JavaScript / NodeJS'
  };

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    final lightMode = Theme.of(context).brightness == Brightness.light;

    return Container(
      constraints: BoxConstraints.expand(),
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Generate API Tool",
            style: TextStyle(
              fontSize: 24*ds.scaleFactor,
            ),
          ),
          kVSpacer5(ds.scaleFactor),
          Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(
              "Select an agent framework & language",
              style: TextStyle(
                  color: lightMode ? Colors.black54 : Colors.white60,
                  fontSize: 15*ds.scaleFactor),
            ),
          ),
          kVSpacer20(ds.scaleFactor),
          Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(
              "Agent Framework",
              style: TextStyle(
                color: lightMode ? Colors.black54 : Colors.white60,
              ),
            ),
          ),
          kVSpacer8(ds.scaleFactor),
          ADPopupMenu<String>(
            value: frameworkMapping[agentFramework],
            values: [
              ...frameworkMapping.keys
                  .map((e) => (e.toString(), frameworkMapping[e].toString())),
            ],
            width: MediaQuery.of(context).size.width * 0.35*ds.scaleFactor,
            tooltip: '',
            onChanged: (x) {
              setState(() {
                agentFramework = x ?? 'OPENAI';

                //AutoGen is Python-Only
                if (agentFramework == 'MICROSOFT_AUTOGEN') {
                  targetLanguage = 'PYTHON';
                }
              });
            },
            isOutlined: true,
          ),
          kVSpacer20(ds.scaleFactor),
          Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(
              "Target Language",
              style: TextStyle(
                color: lightMode ? Colors.black54 : Colors.white60,
              ),
            ),
          ),
          kVSpacer8(ds.scaleFactor),
          ADPopupMenu<String>(
            value: languageMapping[targetLanguage],
            values: [
              ...languageMapping.keys
                  .map((e) => (e.toString(), languageMapping[e].toString())),
            ],
            width: MediaQuery.of(context).size.width * 0.35*ds.scaleFactor,
            tooltip: '',
            onChanged: (x) {
              setState(() {
                targetLanguage = x ?? 'PYTHON';

                //AutoGen is Python-Only
                if (agentFramework == 'MICROSOFT_AUTOGEN') {
                  targetLanguage = 'PYTHON';
                }
              });
            },
            isOutlined: true,
          ),
          kVSpacer20(ds.scaleFactor),
          Wrap(
            runSpacing: 10,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  padding: kPh12,
                  minimumSize: const Size(44, 44),
                ),
                onPressed: () {
                  widget.onGenerateCallback(agentFramework, targetLanguage);
                },
                icon: Icon(
                  Icons.token_outlined,
                ),
                label: const SizedBox(
                  child: Text(
                    "Generate Tool",
                  ),
                ),
              ),
              kHSpacer5(ds.scaleFactor),
              DefaultLLModelSelectorWidget(),
            ],
          ),
        ],
      ),
    );
  }
}

class DefaultLLModelSelectorWidget extends ConsumerWidget {
  const DefaultLLModelSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ds = DesignSystemProvider.of(context);
    final settings = ref.watch(settingsProvider);
    return Opacity(
      opacity: 0.8,
      child: SizedBox(
        width: 200*ds.scaleFactor,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 3),
              child: Text(
                "with",
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black54
                        : Colors.white60,
                    fontSize: 15*ds.scaleFactor),
              ),
            ),
            SizedBox(width: 5*ds.scaleFactor),
            AIModelSelectorButton(
              aiRequestModel:
                  AIRequestModel.fromJson(settings.defaultAIModel ?? {}),
              onModelUpdated: (d) {
                ref.read(settingsProvider.notifier).update(
                    defaultAIModel: d.copyWith(
                        modelConfigs: [],
                        stream: null,
                        systemPrompt: '',
                        userPrompt: '').toJson());
              },
            ),
            kVSpacer5(ds.scaleFactor),
          ],
        ),
      ),
    );
  }
}
