bool showButtonLabelsInBodySuccess(int options, double maxWidth) {
  switch (options) {
    case 0:
      return true;
    case 1:
      return (maxWidth < 300) ? false : true;
    case 2:
      return (maxWidth < 430) ? false : true;
    case 3:
      return (maxWidth < 500) ? false : true;
    default:
      return false;
  }
}

bool showButtonLabelsInViewCodePane(double maxWidth) {
  return (maxWidth < 450) ? false : true;
}
