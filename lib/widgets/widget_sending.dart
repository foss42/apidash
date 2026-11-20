import 'dart:async';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class SendingWidget extends StatefulWidget {
  final DateTime? startSendingTime;
  final bool showTimeElapsed;
  const SendingWidget({
    super.key,
    required this.startSendingTime,
    this.showTimeElapsed = true,
  });

  @override
  State<SendingWidget> createState() => _SendingWidgetState();
}

class _SendingWidgetState extends State<SendingWidget> {
  // The elapsed time lives in a ValueNotifier instead of plain widget state.
  // The timer updates the notifier, so only the Text rebuilds through a
  // ValueListenableBuilder; the Lottie animation is no longer rebuilt on every
  // 100 ms tick, and it is wrapped in a RepaintBoundary so updating the text
  // does not force the animation to repaint.
  final ValueNotifier<int> _elapsed = ValueNotifier<int>(0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.startSendingTime != null) {
      _elapsed.value =
          (DateTime.now().difference(widget.startSendingTime!).inMilliseconds ~/
              100) *
          100;
      _timer = Timer.periodic(const Duration(milliseconds: 100), _updateTimer);
    }
  }

  void _updateTimer(Timer timer) {
    _elapsed.value += 100;
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) _timer?.cancel();
    _elapsed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: RepaintBoundary(child: Lottie.asset(kAssetSendingLottie)),
        ),
        if (widget.showTimeElapsed)
          Padding(
            padding: kPh20t40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.alarm,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 10),
                ValueListenableBuilder<int>(
                  valueListenable: _elapsed,
                  builder: (context, ms, _) {
                    return Visibility(
                      visible: ms >= 0,
                      child: Text(
                        'Time elapsed: ${humanizeDuration(Duration(milliseconds: ms))}',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: kTextStyleButton.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
