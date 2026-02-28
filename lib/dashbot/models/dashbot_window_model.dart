class DashbotWindowModel {
  final double width;
  final double height;
  final double right;
  final double bottom;
  final bool isActive;
  final bool isPopped;
  final bool isHidden;

  const DashbotWindowModel({
    this.width = 400,
    this.height = 515,
    this.right = 50,
    this.bottom = 100,
    this.isActive = false,
    this.isPopped = true,
    this.isHidden = false,
  });

  DashbotWindowModel copyWith({
    double? width,
    double? height,
    double? right,
    double? bottom,
    bool? isActive,
    bool? isPopped,
    bool? isHidden,
  }) {
    return DashbotWindowModel(
      width: width ?? this.width,
      height: height ?? this.height,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      isActive: isActive ?? this.isActive,
      isPopped: isPopped ?? this.isPopped,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}
