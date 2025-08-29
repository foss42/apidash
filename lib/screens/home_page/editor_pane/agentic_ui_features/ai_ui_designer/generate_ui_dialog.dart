import 'package:apidash/consts.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/widgets/widget_sending.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_ui_designer_agentcalls.dart';
import 'framework_selector.dart';
import 'sdui_preview.dart';

void showCustomDialog(BuildContext context, Widget dialogContent) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: dialogContent,
      );
    },
  );
}

class GenerateUIDialog extends ConsumerStatefulWidget {
  final String content;
  const GenerateUIDialog({
    super.key,
    required this.content,
  });

  @override
  ConsumerState<GenerateUIDialog> createState() => _GenerateUIDialogState();
}

class _GenerateUIDialogState extends ConsumerState<GenerateUIDialog> {
  int index = 0;
  TextEditingController controller = TextEditingController();

  String generatedSDUI = '{}';

  Future<String?> generateSDUICode(String apiResponse) async {
    try {
      setState(() {
        index = 1; //Induce Loading
      });
      final res = await generateSDUICodeFromResponse(
        ref: ref,
        apiResponse: apiResponse,
      );
      if (res == null) {
        setState(() {
          index = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Preview Generation Failed!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ));
        return null;
      }
      return res;
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

  Future<void> modifySDUICode(String modificationRequest) async {
    setState(() {
      index = 1; //Induce Loading
    });
    final res = await modifySDUICodeUsingPrompt(
      generatedSDUI: generatedSDUI,
      ref: ref,
      modificationRequest: modificationRequest,
    );
    if (res == null) {
      setState(() {
        index = 2;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Modification Request Failed!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    setState(() {
      generatedSDUI = res;
      index = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (index == 0)
          FrameWorkSelectorPage(
            content: widget.content,
            onNext: (apiResponse, targetLanguage) async {
              print("Generating SDUI Code");
              final sdui = await generateSDUICode(apiResponse);
              if (sdui == null) return;
              setState(() {
                index = 2;
                generatedSDUI = sdui;
              });
            },
          ),
        if (index == 1)
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Container(
                  height: 500,
                  child: SendingWidget(
                    startSendingTime: DateTime.now(),
                    showTimeElapsed: false,
                  ),
                ),
              ),
            ),
          ),
        if (index == 2)
          SDUIPreviewPage(
            key: ValueKey(generatedSDUI.hashCode),
            onModificationRequestMade: modifySDUICode,
            sduiCode: generatedSDUI,
          )
      ],
    );
  }
}

class AIGenerateUIButton extends ConsumerWidget {
  const AIGenerateUIButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.tonalIcon(
      style: FilledButton.styleFrom(
        padding: kPh12,
        minimumSize: const Size(44, 44),
      ),
      onPressed: () {
        final model = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpResponseModel));
        showCustomDialog(
          context,
          GenerateUIDialog(content: model?.formattedBody ?? ""),
        );
      },
      icon: Icon(
        Icons.generating_tokens,
      ),
      label: const SizedBox(
        child: Text(
          kLabelGenerateUI,
        ),
      ),
    );
  }
}
