class UIDesignSystem {
  final double scaleFactor;

  const UIDesignSystem({required this.scaleFactor});

  factory UIDesignSystem.fromScreenWidth(
    double width, {
    double zoom = 1.0,
  }) {
    final baseScale = (width / 1200).clamp(0.5, 2.0);
    return UIDesignSystem(
      scaleFactor: (baseScale * zoom).clamp(0.5, 2.5),
    );
  }
}
