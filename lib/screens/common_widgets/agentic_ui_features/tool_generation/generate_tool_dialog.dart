import 'dart:convert';

import 'package:apidash/apitoolgen/request_consolidator.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/screens/common_widgets/agentic_ui_features/ai_ui_designer/generate_ui_dialog.dart';
import 'package:apidash/utils/agent_utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'generated_tool_codecopy.dart';
import 'tool_requirements_selector.dart';

class GenerateToolButton extends ConsumerWidget {
  const GenerateToolButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.tonalIcon(
      style: FilledButton.styleFrom(
        padding: kPh12,
        minimumSize: const Size(44, 44),
      ),
      onPressed: () async {
        GenerateToolDialog.show(context, ref);
      },
      icon: Icon(
        Icons.token_outlined,
      ),
      label: const SizedBox(
        child: Text(
          "Generate Tool",
        ),
      ),
    );
  }
}

class GenerateToolDialog extends ConsumerStatefulWidget {
  final APIDashRequestDescription requestDesc;
  const GenerateToolDialog({
    super.key,
    required this.requestDesc,
  });

  static show(BuildContext context, WidgetRef ref) {
    final aiRequestModel = ref.watch(
        selectedRequestModelProvider.select((value) => value?.aiRequestModel));
    HttpRequestModel? requestModel = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel));
    final responseModel = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpResponseModel));

    if (aiRequestModel == null && requestModel == null) return;
    if (requestModel == null) return;
    if (responseModel == null) return;

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
      final res = await generateAPIToolUsingRequestData(
        ref: ref,
        requestData: widget.requestDesc.generateREQDATA,
        targetLanguage: selectedLanguage,
        selectedAgent: selectedAgent,
      );
      if (res == null) {
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
      setState(() {
        generatedToolCode = res;
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
