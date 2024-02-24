import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart';
import 'package:flutter/material.dart';

class MethodBox extends StatelessWidget {
  const MethodBox({super.key, required this.method, required this.protocol});
  final HTTPVerb method;
  final Protocol protocol;

  @override
  Widget build(BuildContext context) {
    final (text, color) = switch (protocol) {
      Protocol.http => (
          method.name.substring(0, 3).toUpperCase(),
          getHTTPMethodColor(
            method,
            brightness: Theme.of(context).brightness,
          )
        ),
      Protocol.websocket => ("WS", getProtocolColor(protocol)),
    };

    return SizedBox(
      width: 24,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
