import 'package:apidash/consts.dart';
import 'package:apidash/services/agentic_services/apidash_agent_calls.dart';
import 'package:apidash/widgets/widget_sending.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'framework_selector.dart';
import 'sdui_preview.dart';

Future<T?> showCustomDialog<T>(
  BuildContext context,
  Widget dialogContent, {
  bool useRootNavigator = true,
}) {
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
  const GenerateUIDialog({super.key, required this.content});

  @override
  ConsumerState<GenerateUIDialog> createState() => _GenerateUIDialogState();
}

class _GenerateUIDialogState extends ConsumerState<GenerateUIDialog> {
  int index = 0;
  TextEditingController controller = TextEditingController();

  String generatedSDUI = '{}';

  Future<String?> generateSDUICode(String apiResponse) async {
    setState(() {
      index = 1; //Induce Loading
    });
    final result = await generateSDUICodeFromResponse(
      ref: ref,
      apiResponse: apiResponse,
    );
    return result.when(
      success: (code) => code,
      failure: (exception) {
        setState(() {
          index = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              exception.message,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
        return null;
      },
    );
  }

  Future<void> modifySDUICode(String modificationRequest) async {
    setState(() {
      index = 1; //Induce Loading
    });
    final result = await modifySDUICodeUsingPrompt(
      generatedSDUI: generatedSDUI,
      ref: ref,
      modificationRequest: modificationRequest,
    );
    result.when(
      success: (code) {
        setState(() {
          generatedSDUI = code;
          index = 2;
        });
      },
      failure: (exception) {
        setState(() {
          index = 2;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              exception.message,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      },
    );
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
          ),
      ],
    );
  }
}
