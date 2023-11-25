import 'package:flutter/material.dart';

class HeaderCheckBox extends StatefulWidget {
  final String keyId;
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final ColorScheme? colorScheme;
  const HeaderCheckBox({
    super.key,
    required this.keyId,
    required this.initialValue,
    required this.onChanged,
    this.colorScheme,
  });

  @override
  State<HeaderCheckBox> createState() => _HeaderCheckBoxState();
}

class _HeaderCheckBoxState extends State<HeaderCheckBox> {
  bool _value = true;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void didUpdateWidget(HeaderCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _value = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = widget.colorScheme ?? Theme.of(context).colorScheme;
    return Checkbox(
        key: Key(widget.keyId),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        side: BorderSide(
          color: colorScheme.surfaceVariant,
          width: 2,
        ),
        splashRadius: 0,
        value: _value,
        onChanged: (value) {
          widget.onChanged.call(value!);
          setState(() {
            _value = value;
          });
        });
  }
}
