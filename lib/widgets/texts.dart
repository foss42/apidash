import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class MethodBox extends StatelessWidget {
  const MethodBox({super.key, required this.method});
  final HTTPVerb method;

  @override
  Widget build(BuildContext context) {
    String text = method.name.toUpperCase();
    if (method == HTTPVerb.delete) {
      text = "DEL";
    }
    if (method == HTTPVerb.patch) {
      text = "PAT";
    }
    return SizedBox(
      width: 24,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: getHTTPMethodColor(
            method,
            brightness: Theme.of(context).brightness,
          ),
        ),
      ),
    );
  }
}

class ProtocolBox extends StatelessWidget {
  const ProtocolBox({super.key, required this.protocol});
  final ProtocolType protocol;

  @override
  Widget build(BuildContext context) {
    String text = protocol.name.toUpperCase();
    return SizedBox(
      width: 24,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark
              ? getDarkModeColor(Colors.white)
              : Colors.white,
        ),
      ),
    );
  }
}
