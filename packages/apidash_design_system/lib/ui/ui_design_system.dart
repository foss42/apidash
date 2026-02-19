class UIDesignSystem {
  final double scaleFactor;

  const UIDesignSystem({required this.scaleFactor});

  factory UIDesignSystem.fromScreenWidth(
    double width, {
    double zoom = 1.0,
  }) {
    return UIDesignSystem(
      scaleFactor: zoom.clamp(0.8, 1.2),
    );
  }
}
