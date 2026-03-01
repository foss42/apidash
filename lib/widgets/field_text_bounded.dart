import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class BoundedTextField extends StatefulWidget {
  const BoundedTextField({
    super.key,
    required this.value,
    required this.onChanged,
    this.errorText,
  });

  final String value;
  final void Function(String value) onChanged;
  final String? errorText; //nullable string (can be used globally)

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
    //Assisting in Resetting on Change
    if (widget.value == '') {
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
      height: widget.errorText != null ? 60 : 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.errorText != null
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.surfaceContainerHighest,
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
            errorText: widget.errorText,
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
