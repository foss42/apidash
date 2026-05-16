import 'dart:async';
import 'dart:io';

import 'package:apidash/consts.dart';
import 'package:flutter/foundation.dart';

/// Opens [workingDirectory] in a **native** terminal app (not the embedded shell).
///
/// **macOS:** Writes a short [`.command`][cmd] script to a temp file and runs
/// `open that.command`. Launch Services dispatches to whatever app the user has
/// set as the default for `.command` files (Terminal.app, iTerm, Warp, etc.)—the
/// same mechanism as double‑clicking a `.command` in Finder—so we do not hardcode
/// a specific terminal bundle.
///
/// [cmd]: https://ss64.com/osx/syntax-shellscript.html
Future<void> openExternalTerminal(String workingDirectory) async {
  if (!kIsDesktop) return;
  final dir = Directory(workingDirectory);
  if (!dir.existsSync()) return;

  final path = dir.resolveSymbolicLinksSync();

  if (kIsMacOS) {
    await _openExternalTerminalMacOS(path);
    return;
  }
  if (kIsWindows) {
    try {
      await Process.start(
        'wt',
        ['-d', path],
        mode: ProcessStartMode.detached,
      );
    } catch (_) {
      await Process.start(
        'cmd',
        ['/c', 'start', 'cmd', '/k', 'cd /d "$path"'],
        mode: ProcessStartMode.detached,
      );
    }
    return;
  }
  if (kIsLinux) {
    for (final cmd in <List<String>>[
      ['gnome-terminal', '--working-directory=$path'],
      ['konsole', '--workdir', path],
    ]) {
      try {
        await Process.start(
          cmd.first,
          cmd.sublist(1),
          mode: ProcessStartMode.detached,
        );
        return;
      } catch (_) {}
    }
  }
}

/// Bash/sh single-quoted string literal for arbitrary POSIX paths.
String _bashSingleQuoted(String s) => "'${s.replaceAll("'", "'\\''")}'";

Future<void> _openExternalTerminalMacOS(String posixPath) async {
  final tmp = await Directory.systemTemp.createTemp('apidash_terminal_');
  final commandFile = File('${tmp.path}/OpenInTerminal.command');
  // .command files are executed by the user's default handler for that type.
  await commandFile.writeAsString(
    '#!/bin/sh\n'
    'cd ${_bashSingleQuoted(posixPath)} || exit 1\n'
    'exec "\${SHELL:-/bin/zsh}" -l\n',
  );
  final chmod = await Process.run('chmod', ['+x', commandFile.path]);
  if (chmod.exitCode != 0) {
    debugPrint('chmod +x .command failed: ${chmod.stderr}');
    await _deleteTempDirBestEffort(tmp);
    return;
  }

  final open = await Process.start(
    'open',
    [commandFile.path],
    mode: ProcessStartMode.detached,
  );
  unawaited(open.exitCode);

  _scheduleDeleteTempDir(tmp);
}

void _scheduleDeleteTempDir(Directory dir) {
  Future<void>.delayed(const Duration(seconds: 120), () async {
    try {
      if (await dir.exists()) await dir.delete(recursive: true);
    } catch (_) {}
  });
}

Future<void> _deleteTempDirBestEffort(Directory dir) async {
  try {
    if (await dir.exists()) await dir.delete(recursive: true);
  } catch (_) {}
}
