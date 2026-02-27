import 'package:apidash/apitoolgen/request_consolidator.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/screens/common_widgets/agentic_ui_features/ai_ui_designer/generate_ui_dialog.dart';
import 'package:apidash/services/agentic_services/apidash_agent_calls.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'generated_tool_codecopy.dart';
import 'tool_requirements_selector.dart';

class GenerateToolDialog extends ConsumerStatefulWidget {
  final APIDashRequestDescription requestDesc;
  const GenerateToolDialog({
    super.key,
    required this.requestDesc,
  });

  static Future<T?> show<T>(BuildContext context, WidgetRef ref) {
    final aiRequestModel = ref.watch(
        selectedRequestModelProvider.select((value) => value?.aiRequestModel));
    HttpRequestModel? requestModel = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel));
    final responseModel = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpResponseModel));

    if (aiRequestModel == null && requestModel == null) return Future.value();
    if (requestModel == null) return Future.value();
    if (responseModel == null) return Future.value();

    String? bodyTXT;
    Map? bodyJSON;
    List<Map>? bodyFormData;

    if (aiRequestModel != null) {
      requestModel = aiRequestModel.httpRequestModel!;
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

    return showCustomDialog<T>(
      context,
      GenerateToolDialog(
        requestDesc: reqDesModel,
      ),
      useRootNavigator: true,
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
        index = 1;
      });
      final res = await generateAPIToolUsingRequestData(
        ref: ref,
        requestData: widget.requestDesc.generateREQDATA,
        targetLanguage: selectedLanguage,
        selectedAgent: selectedAgent,
      );
      if (res == null) {
        setState(() {
          generatedToolCode = '';
          index = 0;
        });
// ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "API Tool generation failed!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ));
        return;
      }
      setState(() {
        generatedToolCode = res;
        index = 1;
      });
    } catch (e) {
      setState(() {
        index = 0;
      });
      String errMsg = 'Unexpected Error Occured';
      if (e.toString().contains('NO_DEFAULT_LLM')) {
        errMsg = "Please Select Default AI Model in Settings";
      }
// ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          errMsg,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ));
// ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final dialogWidth = constraints.maxWidth;
      final isExpandedWindow = dialogWidth > WindowWidth.expanded.value;
      final isLargeWindow = dialogWidth > WindowWidth.large.value;
      final isExtraLargeWindow = dialogWidth > WindowWidth.large.value;

      if (isExtraLargeWindow || isLargeWindow || isExpandedWindow) {
        return SizedBox(
          height: 600,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Row(
            children: [
              Flexible(
                  flex: 2,
                  child: ToolRequirementSelectorPage(
                    onGenerateCallback: (agent, lang) {
                      setState(() {
                        selectedLanguage = lang;
                        selectedAgent = agent;
                      });
                      generateAPITool();
                    },
                  )),
              Expanded(
                flex: 3,
                child: GeneratedToolCodeCopyPage(
                  toolCode: generatedToolCode,
                  language: selectedLanguage.trim(),
                ),
              ),
            ],
          ),
        );
      } else {
        return SizedBox(
          height: 600,
          // width: MediaQuery.of(context).size.width * 0.8,
          child: IndexedStack(
            index: index,
            children: [
              Center(
                child: ToolRequirementSelectorPage(
                  onGenerateCallback: (agent, lang) {
                    setState(() {
                      selectedLanguage = lang;
                      selectedAgent = agent;
                    });
                    generateAPITool();
                  },
                ),
              ),
              GeneratedToolCodeCopyPage(
                toolCode: generatedToolCode,
                language: selectedLanguage.trim(),
              ),
            ],
          ),
        );
      }
    });
  }
}