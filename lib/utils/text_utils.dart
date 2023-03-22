String humanizeDuration(Duration? duration) {
  if (duration == null) {
    return "";
  }
  if (duration.inMinutes >= 1) {
    var min = duration.inMinutes;
    var secs = duration.inSeconds.remainder(60);
    return "$min.$secs m";
  }
  if (duration.inSeconds >= 1) {
    var secs = duration.inSeconds;
    var mili = duration.inMilliseconds.remainder(1000) ~/ 10;
    return "$secs.$mili s";
  } else {
    var mili = duration.inMilliseconds.remainder(1000);
    return "$mili ms";
  }
}

String capitalizeFirstLetter(String? text) {
  if (text == null || text == "") {
    return "";
  } else if (text.length == 1) {
    return text.toUpperCase();
  } else {
    var first = text[0];
    var rest = text.substring(1);
    return first.toUpperCase() + rest;
  }
}

String formatHeaderCase(String text) {
  var sp = text.split("-");
  sp = sp.map((e) => capitalizeFirstLetter(e)).toList();
  return sp.join("-");
}
