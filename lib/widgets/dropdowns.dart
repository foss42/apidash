import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class DropdownButtonHttpMethod extends StatefulWidget {
  const DropdownButtonHttpMethod({
    super.key,
    this.method,
    this.onChanged,
  });

  final HTTPVerb? method;
  final void Function(HTTPVerb? value)? onChanged;

  @override
  State<DropdownButtonHttpMethod> createState() =>
      _DropdownButtonHttpMethodState();
}

class _DropdownButtonHttpMethodState extends State<DropdownButtonHttpMethod> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return DropdownButton<HTTPVerb>(
      focusColor: surfaceColor,
      value: widget.method,
      icon: const Icon(Icons.unfold_more_rounded),
      elevation: 4,
      underline: Container(
        height: 0,
      ),
      borderRadius: kBorderRadius12,
      onChanged: widget.onChanged,
      items: HTTPVerb.values.map<DropdownMenuItem<HTTPVerb>>((HTTPVerb value) {
        return DropdownMenuItem<HTTPVerb>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              value.name.toUpperCase(),
              style: kCodeStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: getHTTPMethodColor(
                  value,
                  brightness: Theme.of(context).brightness,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
