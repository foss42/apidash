class DashbotWindowModel {
  final double width;
  final double height;
  final double right;
  final double bottom;
  final bool isActive;

  const DashbotWindowModel({
    this.width = 350,
    this.height = 450,
    this.right = 50,
    this.bottom = 100,
    this.isActive = false,
  });

  DashbotWindowModel copyWith({
    double? width,
    double? height,
    double? right,
    double? bottom,
    bool? isActive,
  }) {
    return DashbotWindowModel(
      width: width ?? this.width,
      height: height ?? this.height,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      isActive: isActive ?? this.isActive,
    );
  }
}
