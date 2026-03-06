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
  static const _invalidNumberMessage = 'Please enter a valid number';

  late final TextEditingController _controller;
  String? _errorText;

  String _getDisplayValue() {
    final value = widget.configuration.value.value;
    return value?.toString() ?? '';
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _getDisplayValue());
  }

  @override
  void didUpdateWidget(covariant AIConfigField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextDisplayValue = _getDisplayValue();
    if (_controller.text != nextDisplayValue) {
      _controller.text = nextDisplayValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String x) {
    if (widget.readonly) return;

    if (widget.numeric) {
      final parsed = ConfigNumericValue.tryParseFinite(x.isEmpty ? '0' : x);
      if (parsed == null) {
        setState(() {
          _errorText = _invalidNumberMessage;
        });
        return;
      }

      if (_errorText != null) {
        setState(() {
          _errorText = null;
        });
      }
      widget.configuration.value.value = parsed;
      widget.onConfigUpdated(widget.configuration);
      return;
    }

    widget.configuration.value.value = x;
    widget.onConfigUpdated(widget.configuration);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: widget.numeric
          ? const TextInputType.numberWithOptions(decimal: true, signed: true)
          : null,
      readOnly: widget.readonly,
      decoration: InputDecoration(errorText: _errorText),
      onChanged: _onChanged,
    );
  }
}
