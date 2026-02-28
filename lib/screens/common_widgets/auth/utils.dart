String getExpirationText(DateTime? tokenExpiration) {
  if (tokenExpiration == null) {
    return "";
  }

  final now = DateTime.now();
  if (tokenExpiration.isBefore(now)) {
    return "Token expired";
  } else {
    // For future times, we want to show "in X hours" instead of "X hours from now"
    final duration = tokenExpiration.difference(now);
    if (duration.inDays > 0) {
      return "Token expires in ${duration.inDays} day${duration.inDays > 1 ? 's' : ''}";
    } else if (duration.inHours > 0) {
      return "Token expires in ${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}";
    } else if (duration.inMinutes > 0) {
      return "Token expires in ${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}";
    } else {
      return "Token expires in less than a minute";
    }
  }
}
