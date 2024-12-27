Duration calculateDurationFromTimestamp(DateTime timestamp) {
  DateTime now = DateTime.now();

  // Calculate the duration
  Duration duration = now.difference(timestamp);

  return duration;
}