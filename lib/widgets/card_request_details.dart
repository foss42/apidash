import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class RequestDetailsCard extends StatelessWidget {
  const RequestDetailsCard({super.key, this.child});

  final Widget? child;
  @override
  @override
  Widget build(BuildContext context) {
    return Card(
      color: kColorTransparent,
      surfaceTintColor: kColorTransparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        borderRadius: kBorderRadius12,
      ),
      elevation: 0,
      child: child,
    );
  }
}
