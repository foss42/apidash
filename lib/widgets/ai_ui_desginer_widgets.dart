import 'dart:convert';
import 'package:apidash/consts.dart';
import 'package:apidash/services/agentic_services/agent_caller.dart';
import 'package:apidash/widgets/widget_sending.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:genai/agentic_engine/blueprint.dart';
import 'package:stac/stac.dart' as stac;
import '../services/agentic_services/agents/agents.dart';

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
    setState(() {
      index = 1; //Induce Loading
    });
    //STEP 1: RESPONSE_ANALYSER (call the Semantic Analysis & IRGen Bots in parallel)
    final step1Res = await Future.wait([
      APIDashAgentCaller.instance.call(
        ResponseSemanticAnalyser(),
        ref: ref,
        input: AgentInputs(query: apiResponse),
      ),
      APIDashAgentCaller.instance.call(
        IntermediateRepresentationGen(),
        ref: ref,
        input: AgentInputs(variables: {
          'VAR_API_RESPONSE': apiResponse,
        }),
      ),
    ]);
    final SA = step1Res[0]?['SEMANTIC_ANALYSIS'];
    final IR = step1Res[1]?['INTERMEDIATE_REPRESENTATION'];

    if (SA == null || IR == null) {
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

    print("Semantic Analysis: $SA");
    print("Intermediate Representation: $IR");

    //STEP 2: STAC_GEN (Generate the SDUI Code)

    final sduiCode = await APIDashAgentCaller.instance.call(
      StacGenBot(),
      ref: ref,
      input: AgentInputs(variables: {
        'VAR_RAW_API_RESPONSE': apiResponse,
        'VAR_INTERMEDIATE_REPR': IR,
        'VAR_SEMANTIC_ANALYSIS': SA,
      }),
    );
    final stacCode = sduiCode?['STAC']?.toString();
    if (stacCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Preview Generation Failed!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ));
      setState(() {
        index = 0;
      });
      return null;
    }
    return sduiCode['STAC'].toString();
  }

  Future<void> modifySDUICode(String modificationRequest) async {
    setState(() {
      index = 1; //Induce Loading
    });

    final res = await APIDashAgentCaller.instance.call(
      StacModifierBot(),
      ref: ref,
      input: AgentInputs(variables: {
        'VAR_CODE': generatedSDUI,
        'VAR_CLIENT_REQUEST': modificationRequest,
      }),
    );

    final SDUI = res?['STAC'];

    if (SDUI == null) {
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
      generatedSDUI = SDUI;
      index = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: index,
      children: [
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
        SDUIPreviewPage(
          key: ValueKey(generatedSDUI.hashCode),
          onModificationRequestMade: modifySDUICode,
          sduiCode: generatedSDUI,
        )
      ],
    );
  }
}

class FrameWorkSelectorPage extends StatefulWidget {
  final String content;
  final Function(String, String) onNext;
  const FrameWorkSelectorPage(
      {super.key, required this.content, required this.onNext});

  @override
  State<FrameWorkSelectorPage> createState() => _FrameWorkSelectorPageState();
}

class _FrameWorkSelectorPageState extends State<FrameWorkSelectorPage> {
  String? selectedFramework;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textContainerdecoration = BoxDecoration(
      color: Color.alphaBlend(
          (Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.primaryContainer)
              .withOpacity(kForegroundOpacity),
          Theme.of(context).colorScheme.surface),
      border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest),
      borderRadius: kBorderRadius8,
    );

    return Container(
      width: MediaQuery.of(context).size.width * 0.6, // Large dialog
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: kP8,
              decoration: textContainerdecoration,
              child: SingleChildScrollView(
                child: TextField(
                  controller: controller,
                  maxLines: null,
                  style: kCodeStyle,
                ),
              ),
            ),
          ),
          kVSpacer20,
          // Text(
          //   "Select Framework",
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // SizedBox(height: 10),
          // DropdownButtonFormField<String>(
          //   dropdownColor: Color(0xFF2D2D2D),
          //   decoration: InputDecoration(
          //     filled: true,
          //     fillColor: Color(0xFF2D2D2D),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(8.0),
          //     ),
          //   ),
          //   value: selectedFramework,
          //   items: ["Flutter", "ReactJS"].map((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(
          //         value,
          //         style: TextStyle(color: Colors.white),
          //       ),
          //     );
          //   }).toList(),
          //   onChanged: (newValue) {
          //     selectedFramework = newValue;
          //     setState(() {});
          //   },
          // ),
          // kVSpacer20,
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonalIcon(
              style: FilledButton.styleFrom(
                padding: kPh12,
                minimumSize: const Size(44, 44),
              ),
              onPressed: () {
                widget.onNext(controller.value.text, "FLUTTER");
              },
              icon: Icon(
                Icons.generating_tokens,
              ),
              label: const SizedBox(
                child: Text(
                  kLabelGenerateUI,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SDUIPreviewPage extends ConsumerStatefulWidget {
  final String sduiCode;
  final Function(String) onModificationRequestMade;
  const SDUIPreviewPage({
    super.key,
    required this.onModificationRequestMade,
    required this.sduiCode,
  });

  @override
  ConsumerState<SDUIPreviewPage> createState() => _SDUIPreviewPageState();
}

class _SDUIPreviewPageState extends ConsumerState<SDUIPreviewPage> {
  bool exportingCode = false;
  String modificationRequest = "";

  exportCode() async {
    setState(() {
      exportingCode = true;
    });
    final ans = await APIDashAgentCaller.instance.call(
      StacToFlutterBot(),
      ref: ref,
      input: AgentInputs(
        variables: {'VAR_CODE': widget.sduiCode},
      ),
    );
    final exportedCode = ans?['CODE'];

    if (exportedCode == null) {
      setState(() {
        exportingCode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Export Failed",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ));
      print("exportCode: Failed; ABORTING");
      return;
    }

    Clipboard.setData(ClipboardData(text: ans['CODE']));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Copied to clipboard!")));
    setState(() {
      exportingCode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6, // Large dialog
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Generated Component",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          kVSpacer20,
          Expanded(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                child: widget.sduiCode == '{}'
                    ? SizedBox()
                    : StacRenderer(
                        stacRepresentation: widget.sduiCode,
                      ),
              ),
            ),
          ),
          kVSpacer20,
          if (!exportingCode) ...[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ADOutlinedTextField(
                hintText: 'Any Modifications?',
                onChanged: (z) {
                  setState(() {
                    modificationRequest = z;
                  });
                },
                maxLines: 3, // Makes the text box taller
              ),
            ),
            kVSpacer20,
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: (exportingCode)
                    ? Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                        margin: EdgeInsets.only(right: 10),
                      )
                    : FilledButton.tonalIcon(
                        style: FilledButton.styleFrom(
                          padding: kPh12,
                          minimumSize: const Size(44, 44),
                        ),
                        onPressed: exportCode,
                        icon: Icon(
                          Icons.download,
                        ),
                        label: const SizedBox(
                          child: Text(
                            "Export Code",
                          ),
                        ),
                      ),
              ),
              kHSpacer10,
              if (!exportingCode)
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      padding: kPh12,
                      minimumSize: const Size(44, 44),
                    ),
                    onPressed: () {
                      if (modificationRequest.isNotEmpty) {
                        widget.onModificationRequestMade(modificationRequest);
                      }
                    },
                    icon: Icon(
                      Icons.generating_tokens,
                    ),
                    label: const SizedBox(
                      child: Text(
                        "Make Modifications",
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class StacRenderer extends StatelessWidget {
  final String stacRepresentation;
  const StacRenderer({super.key, required this.stacRepresentation});

  @override
  Widget build(BuildContext context) {
    // return SingleChildScrollView(
    //   child: SelectableText(stacRepresentation),
    // );
    return stac.StacApp(
      title: 'Component Preview',
      homeBuilder: (context) => Material(
        color: Colors.transparent,
        child: stac.Stac.fromJson(jsonDecode(stacRepresentation), context),
      ),
    );
  }
}
