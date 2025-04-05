import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class LLMProviderCredentialsTextField extends StatefulWidget {
  const LLMProviderCredentialsTextField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final void Function(String value) onChanged;

  @override
  State<LLMProviderCredentialsTextField> createState() =>
      _LLMProviderCredentialsTextFieldState();
}

class _LLMProviderCredentialsTextFieldState
    extends State<LLMProviderCredentialsTextField> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    controller.text = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LLMProviderCredentialsTextField oldWidget) {
    //Assisting in Resetting on Change
    if (widget.value == '') {
      controller.text = widget.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final double width = context.isCompactWindow ? 150 : 220;
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        borderRadius: kBorderRadius8,
      ),
      width: width,
      child: Container(
        transform: Matrix4.translationValues(0, -5, 0),
        child: TextField(
          controller: controller,
          obscureText: true,
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
