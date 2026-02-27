import 'package:apidash/services/agentic_services/apidash_agent_calls.dart';
import 'package:apidash/widgets/widget_sending.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'framework_selector.dart';
import 'sdui_preview.dart';

Future<T?> showCustomDialog<T>(BuildContext context, Widget dialogContent,
    {bool useRootNavigator = true}) {
  return showDialog<T>(
    context: context,
    useRootNavigator: useRootNavigator,
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
// ignore: use_build_context_synchronously
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
      return null;
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
// ignore: use_build_context_synchronously
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
              debugPrint("Generating SDUI Code");
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
            // width: MediaQuery.of(context).size.width * 0.6,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: SizedBox(
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