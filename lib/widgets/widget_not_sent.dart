import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class NotSentWidget extends StatelessWidget {
  const NotSentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.north_east_rounded,
            size: 40,
            color: color,
          ),
          Text(
            kLabelNotSent,
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
