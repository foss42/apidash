import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class RequestDetailsCard extends StatelessWidget {
  const RequestDetailsCard({super.key, this.child});

  final Widget? child;
  @override
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        borderRadius: kBorderRadius12,
      ),
      elevation: 0,
      child: child,
    );
  }
}
