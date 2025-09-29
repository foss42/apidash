import 'package:apidash/screens/common_widgets/agentic_ui_features/ai_ui_designer/sdui_renderer.dart';
import 'package:apidash/services/agentic_services/agent_caller.dart';
import 'package:apidash/services/agentic_services/agents/stac_to_flutter.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      debugPrint("exportCode: Failed; ABORTING");
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
      // width: MediaQuery.of(context).size.width * 0.6, // Large dialog
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Generated Component",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close)),
            ],
          ),
          kVSpacer20,
          Expanded(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: StacRenderer(
                    stacRepresentation: widget.sduiCode,
                    onError: () {
                      Future.delayed(Duration(milliseconds: 200), () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Failed to Display Preview",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.redAccent,
                        ));
                      });
                    },
                  ),
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
                        margin: EdgeInsets.only(right: 10),
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
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
