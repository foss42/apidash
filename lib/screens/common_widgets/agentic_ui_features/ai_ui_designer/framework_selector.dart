import 'package:apidash/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

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
              .withValues(alpha: kForegroundOpacity),
          Theme.of(context).colorScheme.surface),
      border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest),
      borderRadius: kBorderRadius8,
    );

    return Container(
      // width: MediaQuery.of(context).size.width * 0.6, // Large dialog
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
