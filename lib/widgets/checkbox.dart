import 'package:flutter/material.dart';

class HeaderCheckBox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final ColorScheme? colorScheme;
  const HeaderCheckBox({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.colorScheme,
  });

  @override
  State<HeaderCheckBox> createState() => _HeaderCheckBoxState();
}

class _HeaderCheckBoxState extends State<HeaderCheckBox> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = widget.colorScheme ?? Theme.of(context).colorScheme;
    return Checkbox(
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
