import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:apidash/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pty/flutter_pty.dart';
import 'package:path/path.dart' as p;
import 'package:xterm/xterm.dart';

/// VS Code–style integrated shell: [flutter_pty] + [xterm] (same stack as Bruno’s
/// Electron app uses node-pty + xterm.js).
class ShellTerminalView extends StatefulWidget {
  const ShellTerminalView({
    super.key,
    required this.workingDirectory,
  });

  /// When null, uses [defaultWorkingDirectory].
  final String? workingDirectory;

  static String defaultWorkingDirectory() {
    if (kIsWeb) return '';
    if (Platform.isWindows) {
      return Platform.environment['USERPROFILE'] ?? r'C:\';
    }
    return Platform.environment['HOME'] ?? '/';
  }

  @override
  State<ShellTerminalView> createState() => _ShellTerminalViewState();
}

class _ShellTerminalViewState extends State<ShellTerminalView> {
  late final Terminal _terminal;
  late final TerminalController _terminalController;
  Pty? _pty;
  StreamSubscription<Uint8List>? _outSub;
  String? _error;

  @override
  void initState() {
    super.initState();
    _terminal = Terminal(
      maxLines: 10000,
      platform: _mapPlatform(),
    );
    _terminalController = TerminalController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startPty());
  }

  TerminalTargetPlatform _mapPlatform() {
    if (kIsWeb) return TerminalTargetPlatform.web;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => TerminalTargetPlatform.android,
      TargetPlatform.iOS => TerminalTargetPlatform.ios,
      TargetPlatform.fuchsia => TerminalTargetPlatform.fuchsia,
      TargetPlatform.linux => TerminalTargetPlatform.linux,
      TargetPlatform.macOS => TerminalTargetPlatform.macos,
      TargetPlatform.windows => TerminalTargetPlatform.windows,
    };
  }

  String _resolvedCwd() {
    final raw = widget.workingDirectory;
    if (raw != null && raw.isNotEmpty) {
      final d = Directory(raw);
      if (d.existsSync()) return raw;
    }
    return ShellTerminalView.defaultWorkingDirectory();
  }

  String _shellExecutable() {
    if (kIsWeb) return '';
    if (Platform.isWindows) {
      return Platform.environment['ComSpec'] ?? 'cmd.exe';
    }
    final fromEnv = Platform.environment['SHELL']?.trim();
    if (fromEnv != null && fromEnv.isNotEmpty) {
      try {
        final t = FileSystemEntity.typeSync(fromEnv, followLinks: true);
        if (t != FileSystemEntityType.notFound) return fromEnv;
      } catch (_) {}
    }
    if (Platform.isMacOS) return '/bin/zsh';
    return '/bin/bash';
  }

  /// Interactive shell without reading startup files (avoids broken ~/.zshenv etc.).
  /// flutter_pty only copies a few keys from [Platform.environment] unless we pass more.
  List<String> _shellArguments(String executable) {
    if (kIsWeb || Platform.isWindows) return const [];
    switch (p.basename(executable)) {
      case 'zsh':
        return const ['-if'];
      case 'bash':
        return const ['--noprofile', '--norc', '-i'];
      case 'fish':
        return const ['--no-config', '-i'];
      default:
        return const ['-i'];
    }
  }

  /// Pass a full environment map: the native PTY layer only merges a subset from
  /// [Platform.environment] unless we supply overrides for everything we need.
  ///
  /// In zsh, [PS1] is an alias for [PROMPT]; setting both overwrites with two
  /// different formats. Bash-style `\u@\h` in [PS1] is printed literally by zsh.
  Map<String, String>? _ptyEnvironment(String shellExecutable) {
    if (kIsWeb) return null;
    if (Platform.isWindows) return null;
    final env = Map<String, String>.from(Platform.environment);
    env.remove('PROMPT');
    env.remove('PS1');
    if (env['PATH']?.trim().isEmpty ?? true) {
      env['PATH'] =
          '/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin';
    }
    if (env['HOME']?.trim().isEmpty ?? true) {
      env['HOME'] = ShellTerminalView.defaultWorkingDirectory();
    }
    env['TERM'] = 'xterm-256color';
    if (env['LANG']?.trim().isEmpty ?? true) {
      env['LANG'] = 'en_US.UTF-8';
    }
    // Startup files are skipped (-f / --norc); set one prompt format per shell.
    final shellBase = p.basename(shellExecutable);
    if (shellBase == 'zsh') {
      env['PROMPT'] = r'%n@%m %~ %# ';
    } else {
      // bash, sh, dash, etc.
      env['PS1'] = r'\u@\h:\w\$ ';
    }
    return env;
  }

  Future<void> _startPty() async {
    if (kIsWeb) {
      setState(() => _error = 'Integrated shell is not available in the web build.');
      return;
    }

    await _disposePty();
    setState(() => _error = null);

    final cwd = _resolvedCwd();
    final shell = _shellExecutable();
    final args = _shellArguments(shell);
    // Avoid tiny PTY geometry before first layout (flutter_pty / shells can misbehave).
    final cols = math.max(40, _terminal.viewWidth);
    final rows = math.max(12, _terminal.viewHeight);

    try {
      final pty = Pty.start(
        shell,
        arguments: args,
        workingDirectory: cwd,
        environment: _ptyEnvironment(shell),
        columns: cols,
        rows: rows,
      );
      _pty = pty;

      _outSub = pty.output.listen(
        (data) {
          try {
            _terminal.write(utf8.decode(data, allowMalformed: true));
          } catch (_) {
            _terminal.write(String.fromCharCodes(data));
          }
        },
        onError: (_) {},
      );

      pty.exitCode.then((code) {
        if (mounted) {
          _terminal.write('\r\n[exit code: $code]\r\n');
        }
      });

      _terminal.onOutput = (data) {
        _pty?.write(Uint8List.fromList(utf8.encode(data)));
      };
      _terminal.onResize = (w, h, pw, ph) {
        if (w < 2 || h < 2) return;
        _pty?.resize(h, w);
      };

      if (mounted) setState(() {});
    } catch (e, st) {
      debugPrint('ShellTerminalView: failed to start PTY: $e\n$st');
      if (mounted) {
        setState(() => _error = 'Could not start shell: $e');
      }
    }
  }

  Future<void> _disposePty() async {
    await _outSub?.cancel();
    _outSub = null;
    _terminal.onOutput = null;
    _terminal.onResize = null;
    try {
      _pty?.kill();
    } catch (_) {}
    _pty = null;
  }

  @override
  void didUpdateWidget(ShellTerminalView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.workingDirectory != widget.workingDirectory) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startPty());
    }
  }

  @override
  void dispose() {
    _disposePty();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Center(
        child: Text('Integrated shell is not available in the browser.'),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      );
    }

    return ColoredBox(
      color: const Color(0xFF1E1E1E),
      child: TerminalView(
        _terminal,
        controller: _terminalController,
        autofocus: kIsDesktop,
        theme: TerminalThemes.defaultTheme,
        onSecondaryTapDown: (details, offset) async {
          final selection = _terminalController.selection;
          if (selection != null) {
            final text = _terminal.buffer.getText(selection);
            _terminalController.clearSelection();
            await Clipboard.setData(ClipboardData(text: text));
          } else {
            final data = await Clipboard.getData('text/plain');
            final text = data?.text;
            if (text != null) {
              _terminal.paste(text);
            }
          }
        },
      ),
    );
  }
}
