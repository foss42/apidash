import 'dart:async';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class SendingWidget extends StatefulWidget {
  final DateTime? startSendingTime;
  const SendingWidget({
    super.key,
    required this.startSendingTime,
  });

  @override
  State<SendingWidget> createState() => _SendingWidgetState();
}

class _SendingWidgetState extends State<SendingWidget> {
  int _millisecondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.startSendingTime != null) {
      _millisecondsElapsed =
          (DateTime.now().difference(widget.startSendingTime!).inMilliseconds ~/
                  100) *
              100;
      _timer = Timer.periodic(const Duration(milliseconds: 100), _updateTimer);
    }
  }

  void _updateTimer(Timer timer) {
    setState(() {
      _millisecondsElapsed += 100;
    });
  }

  @override
  void dispose() {
    if (_timer != null && _timer!.isActive) _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Lottie.asset(kAssetSendingLottie),
        ),
        Padding(
          padding: kPh20t40,
          child: Visibility(
            visible: _millisecondsElapsed >= 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.alarm,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Time elapsed: ${humanizeDuration(Duration(milliseconds: _millisecondsElapsed))}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: kTextStyleButton.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
