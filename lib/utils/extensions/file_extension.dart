extension FileExtension on String {
  String get fileName {
    return split(r'\').last;
  }
}
