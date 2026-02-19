import 'ui_design_system.dart';
import 'package:flutter/material.dart';

class DesignSystemProvider extends InheritedWidget {
  final UIDesignSystem designSystem;

  const DesignSystemProvider({
    super.key,
    required this.designSystem,
    required super.child,
  });

  static UIDesignSystem of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<DesignSystemProvider>();
    assert(provider != null, 'No DesignSystemProvider found in context');
    return provider!.designSystem;
  }

  @override
  bool updateShouldNotify(covariant DesignSystemProvider oldWidget) {
    return oldWidget.designSystem != designSystem;
  }
}
