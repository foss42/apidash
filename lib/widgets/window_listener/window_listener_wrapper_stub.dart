import 'package:flutter/material.dart';

class WindowListenerWrapper extends StatelessWidget {
  const WindowListenerWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
