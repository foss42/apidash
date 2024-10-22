import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/extensions/extensions.dart';

class DropdownButtonHttpMethod extends StatelessWidget {
  const DropdownButtonHttpMethod({
    super.key,
    this.method,
    this.onChanged,
  });

  final HTTPVerb? method;
  final void Function(HTTPVerb? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return DropdownButton<HTTPVerb>(
      focusColor: surfaceColor,
      value: method,
      icon: const Icon(Icons.unfold_more_rounded),
      elevation: 4,
      underline: Container(
        height: 0,
      ),
      borderRadius: kBorderRadius12,
      onChanged: onChanged,
      items: HTTPVerb.values.map<DropdownMenuItem<HTTPVerb>>((HTTPVerb value) {
        return DropdownMenuItem<HTTPVerb>(
          value: value,
          child: Padding(
            padding: EdgeInsets.only(left: context.isMediumWindow ? 8 : 16),
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
