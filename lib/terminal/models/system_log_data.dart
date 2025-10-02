class SystemLogData {
  SystemLogData({required this.category, required this.message, this.stack});
  final String category; // ui | provider | io | storage | unknown
  final String message;
  final String? stack;
}
