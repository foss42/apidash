import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class BoundedTextField extends StatefulWidget {
  const BoundedTextField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final void Function(String value) onChanged;

  @override
  State<BoundedTextField> createState() => _BoundedTextFieldState();
}

class _BoundedTextFieldState extends State<BoundedTextField> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    controller.text = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BoundedTextField oldWidget) {
    // Sync controller when parent value changes and differs from current text
    if (widget.value != oldWidget.value && widget.value != controller.text) {
      controller.text = widget.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final double width = context.isCompactWindow ? 150 : 220;
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        borderRadius: kBorderRadius8,
      ),
      width: double.infinity,
      child: Container(
        transform: Matrix4.translationValues(0, -5, 0),
        child: TextField(
          controller: controller,
          // obscureText: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 10),
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
