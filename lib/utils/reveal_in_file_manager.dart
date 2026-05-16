import 'dart:io';

import 'package:apidash/consts.dart';

/// Opens the system file manager with [directoryPath] selected (desktop only).
Future<void> revealInFileManager(String directoryPath) async {
  if (!kIsDesktop) return;
  final dir = Directory(directoryPath);
  if (!dir.existsSync()) return;

  if (kIsMacOS) {
    await Process.start('open', [directoryPath], mode: ProcessStartMode.detached);
  } else if (kIsWindows) {
    await Process.start('explorer', [directoryPath], mode: ProcessStartMode.detached);
  } else if (kIsLinux) {
    await Process.start('xdg-open', [directoryPath], mode: ProcessStartMode.detached);
  }
}
