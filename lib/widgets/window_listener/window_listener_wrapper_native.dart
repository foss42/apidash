import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import '../../providers/providers.dart';

class WindowListenerWrapper extends ConsumerStatefulWidget {
  const WindowListenerWrapper({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<WindowListenerWrapper> createState() =>
      _WindowListenerWrapperState();
}

class _WindowListenerWrapperState extends ConsumerState<WindowListenerWrapper>
    with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _init();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void _init() async {
    await windowManager.setPreventClose(true);
    if (mounted) setState(() {});
  }

  @override
  void onWindowResized() {
    windowManager.getSize().then((value) {
      ref.read(settingsProvider.notifier).update(size: value);
    });
    windowManager.getPosition().then((value) {
      ref.read(settingsProvider.notifier).update(offset: value);
    });
  }

  @override
  void onWindowMoved() {
    windowManager.getPosition().then((value) {
      ref.read(settingsProvider.notifier).update(offset: value);
    });
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      if (ref.watch(
              settingsProvider.select((value) => value.promptBeforeClosing)) &&
          ref.watch(hasUnsavedChangesProvider)) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Save Changes'),
            content:
                const Text('Want to save changes before you close API Dash?'),
            actions: [
              OutlinedButton(
                child: const Text('No'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await windowManager.destroy();
                },
              ),
              FilledButton(
                child: const Text('Save'),
                onPressed: () async {
                  await ref
                      .read(collectionStateNotifierProvider.notifier)
                      .saveData();
                  if (context.mounted) Navigator.of(context).pop();
                  await windowManager.destroy();
                },
              ),
            ],
          ),
        );
      } else {
        await windowManager.destroy();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
