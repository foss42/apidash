extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    if (length == 1) {
      return toUpperCase();
    }
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String clip(int limit) {
    if (limit < 0) {
      return '...';
    }
    if (length <= limit) {
      return this;
    }
    return "${substring(0, limit)}...";
  }
}
