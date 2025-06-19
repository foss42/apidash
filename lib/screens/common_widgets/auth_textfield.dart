import 'package:apidash_design_system/tokens/measurements.dart';
import 'package:apidash_design_system/tokens/typography.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final Function(String)? onChanged;

  const AuthTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    this.isObscureText = false,
  });

  @override
  State<AuthTextField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isObscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.hintText,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.controller,
            style: kCodeStyle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width - 80),
              contentPadding: kP10,
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.bodySmall,
              suffixIcon: widget.isObscureText
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: _toggleVisibility,
                    )
                  : null,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "${widget.hintText} cannot be empty!";
              }
              return null;
            },
            obscureText: _obscureText,
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}
