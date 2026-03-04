import 'package:flutter/material.dart';
import '../models/models.dart';

class AIConfigField extends StatefulWidget {
  final bool numeric;
  final ModelConfig configuration;
  final Function(ModelConfig) onConfigUpdated;
  final bool readonly;
  const AIConfigField({
    super.key,
    this.numeric = false,
    required this.configuration,
    required this.onConfigUpdated,
    this.readonly = false,
  });

  @override
  State<AIConfigField> createState() => _AIConfigFieldState();
}

class _AIConfigFieldState extends State<AIConfigField> {
  static const _kInvalidNumericValueText = 'Invalid numeric value';
  String? _errorText;

  void _setErrorText(String? value) {
    if (_errorText == value) return;
    setState(() {
      _errorText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.configuration.value.value.toString(),
      enabled: !widget.readonly,
      decoration: InputDecoration(errorText: _errorText),
      onChanged: (x) {
        if (widget.readonly) return;
        if (widget.numeric) {
          if (x.isEmpty) x = '0';
          final parsed = num.tryParse(x);
          if (parsed == null || !parsed.isFinite) {
            _setErrorText(_kInvalidNumericValueText);
            return;
          }
          _setErrorText(null);
          widget.configuration.value.value = parsed;
        } else {
          _setErrorText(null);
          widget.configuration.value.value = x;
        }
        widget.onConfigUpdated(widget.configuration);
      },
    );
  }
}
