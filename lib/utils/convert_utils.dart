import 'dart:typed_data';
import 'dart:convert';
import 'package:apidash_core/apidash_core.dart';
import 'package:intl/intl.dart';

String humanizeDate(DateTime? date) {
  if (date == null) {
    return "";
  }
  return DateFormat('MMMM d, yyyy').format(date);
}

String humanizeTime(DateTime? time) {
  if (time == null) {
    return "";
  }
  return DateFormat('hh:mm:ss a').format(time);
}

String humanizeDuration(Duration? duration) {
  if (duration == null) {
    return "";
  }
  if (duration.inMinutes >= 1) {
    var min = duration.inMinutes;
    var secs = duration.inSeconds.remainder(60) * 100 ~/ 60;
    var secondsPadding = secs < 10 ? "0" : "";
    return "$min.$secondsPadding$secs m";
  }
  if (duration.inSeconds >= 1) {
    var secs = duration.inSeconds;
    var mili = duration.inMilliseconds.remainder(1000) ~/ 10;
    var milisecondsPadding = mili < 10 ? "0" : "";
    return "$secs.$milisecondsPadding$mili s";
  } else {
    var mili = duration.inMilliseconds;
    return "$mili ms";
  }
}

String audioPosition(Duration? duration) {
  if (duration == null) return "";
  var min = duration.inMinutes;
  var secs = duration.inSeconds.remainder(60);
  var secondsPadding = secs < 10 ? "0" : "";
  return "$min:$secondsPadding$secs";
}

String formatHeaderCase(String text) {
  var sp = text.split("-");
  sp = sp.map((e) => e.capitalize()).toList();
  return sp.join("-");
}

String padMultilineString(String text, int padding,
    {bool firstLinePadded = false}) {
  var lines = kSplitter.convert(text);
  int start = firstLinePadded ? 0 : 1;
  for (start; start < lines.length; start++) {
    lines[start] = ' ' * padding + lines[start];
  }
  return lines.join("\n");
}

Uint8List? stringToBytes(String? text) {
  if (text == null) {
    return null;
  } else {
    var l = utf8.encode(text);
    var bytes = Uint8List.fromList(l);
    return bytes;
  }
}

Uint8List jsonMapToBytes(Map<String, dynamic>? map) {
  if (map == null) {
    return Uint8List.fromList([]);
  } else {
    String text = kJsonEncoder.convert(map);
    var l = utf8.encode(text);
    var bytes = Uint8List.fromList(l);
    return bytes;
  }
}
