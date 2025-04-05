import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widget_sending.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

void showCustomDialog(BuildContext context, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Color.fromARGB(255, 16, 20, 24), // Dark background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: DialogContents(
          content: content,
        ),
      );
    },
  );
}

class DialogContents extends StatefulWidget {
  final String content;
  const DialogContents({
    super.key,
    required this.content,
  });

  @override
  State<DialogContents> createState() => _DialogContentsState();
}

class _DialogContentsState extends State<DialogContents> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: index,
      children: [
        FrameWorkSelectorPage(
          content: widget.content,
          onNext: () {
            setState(() {
              index = 1;
            });
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    index = 2;
                  });
                },
                child: Container(
                  height: 500,
                  child: SendingWidget(
                    startSendingTime: DateTime.now(),
                  ),
                ),
              ),
            ),
          ),
        ),
        EditorPage(
          onNext: () {},
        )
      ],
    );
  }
}

class FrameWorkSelectorPage extends StatefulWidget {
  final String content;
  final Function() onNext;
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
                widget.onNext();
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

class EditorPage extends StatefulWidget {
  final Function() onNext;
  const EditorPage({super.key, required this.onNext});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
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
                child: Container(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          kVSpacer20,
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black, // Dark background
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey, // Border color
                width: 1,
              ),
            ),
            child: TextField(
              maxLines: 3, // Makes the text box taller
              style: TextStyle(color: Colors.white), // White text
              decoration: InputDecoration(
                hintText: 'Any Modifications?',
                hintStyle: TextStyle(color: Colors.grey), // Grey hint text
                border: InputBorder.none, // Removes the default border
                contentPadding: EdgeInsets.all(16), // Padding inside the box
              ),
            ),
          ),
          kVSpacer20,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    padding: kPh12,
                    minimumSize: const Size(44, 44),
                  ),
                  onPressed: () {
                    widget.onNext();
                  },
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
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    padding: kPh12,
                    minimumSize: const Size(44, 44),
                  ),
                  onPressed: () {
                    widget.onNext();
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
