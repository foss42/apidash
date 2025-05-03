import 'package:apidash/apitoolgen/request_consolidator.dart';
import 'package:apidash/apitoolgen/tool_templates.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/services/agentic_services/agent_caller.dart';
import 'package:apidash/services/agentic_services/agents/apitool_bodygen.dart';
import 'package:apidash/services/agentic_services/agents/apitool_funcgen.dart';
import 'package:apidash/widgets/ai_ui_desginer_widgets.dart';
import 'package:apidash/widgets/button_copy.dart';
import 'package:apidash/widgets/previewer_code.dart';
import 'package:apidash/widgets/widget_sending.dart';
import 'package:apidash_design_system/tokens/tokens.dart';
import 'package:apidash_design_system/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genai/agentic_engine/blueprint.dart';

class GenerateToolDialog extends ConsumerStatefulWidget {
  final APIDashRequestDescription requestDesc;
  const GenerateToolDialog({
    super.key,
    required this.requestDesc,
  });

  @override
  ConsumerState<GenerateToolDialog> createState() => _GenerateToolDialogState();
}

class _GenerateToolDialogState extends ConsumerState<GenerateToolDialog> {
  int index = 0;
  TextEditingController controller = TextEditingController();

  String selectedLanguage = 'PYTHON';
  String selectedAgent = 'GEMINI';
  String? generatedToolCode = '';

  generateAPITool() async {
    setState(() {
      generatedToolCode = null;
    });
    final toolfuncRes = await APIDashAgentCaller.instance.call(
      APIToolFunctionGenerator(),
      ref: ref,
      input: AgentInputs(variables: {
        'REQDATA': widget.requestDesc.generateREQDATA,
        'TARGET_LANGUAGE': selectedLanguage,
      }),
    );
    if (toolfuncRes == null) {
      setState(() {
        generatedToolCode = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "API Tool generation failed!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    String toolCode = toolfuncRes!['FUNC'];

    final toolres = await APIDashAgentCaller.instance.call(
      ApiToolBodyGen(),
      ref: ref,
      input: AgentInputs(variables: {
        'TEMPLATE': APIToolGenTemplateSelector.getTemplate(
                selectedLanguage, selectedAgent)
            .substitutePromptVariable('FUNC', toolCode),
      }),
    );
    if (toolres == null) {
      setState(() {
        generatedToolCode = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "API Tool generation failed!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    String toolDefinition = toolres!['TOOL'];

    setState(() {
      generatedToolCode = toolDefinition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        children: [
          Expanded(child: ToolRequirementSelectorPage(
            onGenerateCallback: (agent, lang) {
              setState(() {
                selectedLanguage = lang;
                selectedAgent = agent;
              });
              generateAPITool();
            },
          )),
          GeneratedToolCodeCopyPage(
            toolCode: generatedToolCode,
            language: 'javascript',
          ),
        ],
      ),
    );
  }
}

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
    return Container(
      width: MediaQuery.of(context).size.width * 0.4, // Large dialog
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Generate API Tool",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          kVSpacer5,
          Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(
              "Select an agent framework & language",
              style: TextStyle(color: Colors.white60, fontSize: 15),
            ),
          ),
          kVSpacer20,
          Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(
              "Agent Framework",
              style: TextStyle(color: Colors.white60),
            ),
          ),
          kVSpacer8,
          ADPopupMenu<String>(
            value: frameworkMapping[agentFramework],
            values: [
              ...frameworkMapping.keys
                  .map((e) => (e.toString(), frameworkMapping[e].toString())),
            ],
            width: MediaQuery.of(context).size.width * 0.35,
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
          kVSpacer20,
          Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(
              "Target Language",
              style: TextStyle(color: Colors.white60),
            ),
          ),
          kVSpacer8,
          ADPopupMenu<String>(
            value: languageMapping[targetLanguage],
            values: [
              ...languageMapping.keys
                  .map((e) => (e.toString(), languageMapping[e].toString())),
            ],
            width: MediaQuery.of(context).size.width * 0.35,
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
          kVSpacer20,
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
        ],
      ),
    );
  }
}

class GeneratedToolCodeCopyPage extends StatelessWidget {
  final String? toolCode;
  final String language;
  const GeneratedToolCodeCopyPage(
      {super.key, required this.toolCode, required this.language});

  @override
  Widget build(BuildContext context) {
    var codeTheme = Theme.of(context).brightness == Brightness.light
        ? kLightCodeTheme
        : kDarkCodeTheme;

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
            color: Colors.white12,
            size: 500,
          ),
        ),
      );
    }

    return Container(
      color: const Color.fromARGB(255, 28, 28, 28),
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width * 0.50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CopyButton(
            toCopy: toolCode!,
            showLabel: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
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
