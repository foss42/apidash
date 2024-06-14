extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String clip(int limit) {
    if (length <= limit) {
      return this;
    }
    return "${substring(0, limit)}...";
  }
}
