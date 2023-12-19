import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FormDataField extends StatefulWidget {
  const FormDataField({
    super.key,
    required this.keyId,
    this.initialValue,
    this.hintText,
    this.onChanged,
    this.colorScheme,
    this.formDataType,
    this.onFormDataTypeChanged,
  });

  final String keyId;
  final String? initialValue;
  final String? hintText;
  final void Function(String)? onChanged;
  final ColorScheme? colorScheme;
  final FormDataType? formDataType;
  final void Function(FormDataType?)? onFormDataTypeChanged;

  @override
  State<FormDataField> createState() => _FormDataFieldState();
}

class _FormDataFieldState extends State<FormDataField> {
  TextEditingController valueController = TextEditingController();
  @override
  void initState() {
    valueController.text = widget.initialValue ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = widget.colorScheme ?? Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: TextFormField(
            controller: valueController,
            key: Key(widget.keyId),
            style: kCodeStyle.copyWith(
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintStyle: kCodeStyle.copyWith(
                color: colorScheme.outline.withOpacity(
                  kHintOpacity,
                ),
              ),
              hintText: widget.hintText,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: colorScheme.primary.withOpacity(
                    kHintOpacity,
                  ),
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: colorScheme.surfaceVariant,
                ),
              ),
            ),
            onChanged: widget.onChanged,
          ),
        ),
        Expanded(
          child: DropdownButtonFormData(
            formDataType: widget.formDataType,
            onChanged: (p0) {
              if (widget.onFormDataTypeChanged != null) {
                widget.onFormDataTypeChanged!(p0);
                valueController.clear();
              }
            },
          ),
        )
      ],
    );
  }
}
