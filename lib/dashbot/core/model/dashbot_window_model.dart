class DashbotWindowModel {
  final double width;
  final double height;
  final double right;
  final double bottom;
  final bool isActive;
  final bool isPopped;

  const DashbotWindowModel({
    this.width = 375,
    this.height = 460,
    this.right = 50,
    this.bottom = 100,
    this.isActive = false,
    this.isPopped = false,
  });

  DashbotWindowModel copyWith({
    double? width,
    double? height,
    double? right,
    double? bottom,
    bool? isActive,
    bool? isPopped,
  }) {
    return DashbotWindowModel(
      width: width ?? this.width,
      height: height ?? this.height,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      isActive: isActive ?? this.isActive,
      isPopped: isPopped ?? this.isPopped,
    );
  }
}
