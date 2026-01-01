import 'package:flutter/material.dart';

import 'package:window_manager/window_manager.dart';

const double kWindowCaptionHeight = 30;

class WindowCaption extends StatefulWidget {
  const WindowCaption({
    super.key,
    this.backgroundColor,
    this.brightness,
  });

  final Color? backgroundColor;
  final Brightness? brightness;

  @override
  State<WindowCaption> createState() => _WindowCaptionState();
}

class _WindowCaptionState extends State<WindowCaption> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanStart: (details) {
              windowManager.startDragging();
            },
            child: const SizedBox(
              height: double.infinity,
            ),
          ),
        ),
        WindowCaptionButton.minimize(
          brightness: widget.brightness,
          onPressed: () async {
            bool isMinimized = await windowManager.isMinimized();
            if (isMinimized) {
              windowManager.restore();
            } else {
              windowManager.minimize();
            }
          },
        ),
        FutureBuilder<bool>(
          future: windowManager.isMaximized(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == true) {
              return WindowCaptionButton.unmaximize(
                brightness: widget.brightness,
                onPressed: () {
                  windowManager.unmaximize();
                },
              );
            }
            return WindowCaptionButton.maximize(
              brightness: widget.brightness,
              onPressed: () {
                windowManager.maximize();
              },
            );
          },
        ),
        WindowCaptionButton.close(
          brightness: widget.brightness,
          onPressed: () {
            windowManager.close();
          },
        ),
      ],
    );
  }

  @override
  void onWindowMaximize() {
    setState(() {});
  }

  @override
  void onWindowUnmaximize() {
    setState(() {});
  }
}
