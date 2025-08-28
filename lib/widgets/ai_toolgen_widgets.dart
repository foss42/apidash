import 'dart:convert';

import 'package:apidash/apitoolgen/request_consolidator.dart';
import 'package:apidash/apitoolgen/tool_templates.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/ai/ai_model_selector_button.dart';
import 'package:apidash/services/agentic_services/agent_caller.dart';
import 'package:apidash/services/agentic_services/agents/apitool_bodygen.dart';
import 'package:apidash/services/agentic_services/agents/apitool_funcgen.dart';
import 'package:apidash/widgets/ai_ui_desginer_widgets.dart';
import 'package:apidash/widgets/button_copy.dart';
import 'package:apidash/widgets/previewer_code.dart';
import 'package:apidash/widgets/widget_sending.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/tokens/tokens.dart';
import 'package:apidash_design_system/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genai/agentic_engine/blueprint.dart';

import '../providers/providers.dart';

class GenerateToolDialog extends ConsumerStatefulWidget {
  final APIDashRequestDescription requestDesc;
  const GenerateToolDialog({
    super.key,
    required this.requestDesc,
  });

  static show(BuildContext context, WidgetRef ref) {
    final requestModel = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel));
    final responseModel = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpResponseModel));

    if (requestModel == null) return;
    if (responseModel == null) return;

    String? bodyTXT;
    Map? bodyJSON;
    List<Map>? bodyFormData;

    if (requestModel.bodyContentType == ContentType.formdata) {
      bodyFormData = requestModel.formDataMapList;
    } else if (requestModel.bodyContentType == ContentType.json) {
      bodyJSON = jsonDecode(requestModel.body.toString());
    } else {
      bodyTXT = requestModel.body!;
    }

    final reqDesModel = APIDashRequestDescription(
      endpoint: requestModel.url,
      method: requestModel.method.name.toUpperCase(),
      responseType: responseModel.contentType.toString(),
      headers: requestModel.headersMap,
      response: responseModel.body,
      formData: bodyFormData,
      bodyTXT: bodyTXT,
      bodyJSON: bodyJSON,
    );

    showCustomDialog(
      context,
      GenerateToolDialog(
        requestDesc: reqDesModel,
      ),
    );
  }

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
    try {
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
    } catch (e) {
      String errMsg = 'Unexpected Error Occured';
      if (e.toString().contains('NO_DEFAULT_LLM')) {
        errMsg = "Please Select Default AI Model in Settings";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          errMsg,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ));
      Navigator.pop(context);
    }
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
            language: selectedLanguage.trim(),
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
    final lightMode = Theme.of(context).brightness == Brightness.light;

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
            ),
          ),
          kVSpacer5,
          Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(
              "Select an agent framework & language",
              style: TextStyle(
                  color: lightMode ? Colors.black54 : Colors.white60,
                  fontSize: 15),
            ),
          ),
          kVSpacer20,
          Padding(
            padding: EdgeInsets.only(left: 3),
            child: Text(
              "Agent Framework",
              style: TextStyle(
                color: lightMode ? Colors.black54 : Colors.white60,
              ),
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
              style: TextStyle(
                color: lightMode ? Colors.black54 : Colors.white60,
              ),
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
          Row(
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
              kHSpacer5,
              DefaultLLModelSelectorWidget(),
            ],
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

class DefaultLLModelSelectorWidget extends ConsumerWidget {
  const DefaultLLModelSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return Opacity(
      opacity: 0.8,
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
                  fontSize: 15),
            ),
          ),
          SizedBox(width: 5),
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
          kVSpacer5,
        ],
      ),
    );
  }
}
