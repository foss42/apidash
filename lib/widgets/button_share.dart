import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:apidash/consts.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
    required this.toShare,
    this.showLabel = true,
  });

  final String toShare;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    onPressed() async {
      try {
        final box = context.findRenderObject() as RenderBox?;
        await Share.share(
          toShare,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        );
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        sm.hideCurrentSnackBar();
        sm.showSnackBar(getSnackBar("Cannot share"));
      }
    }

    return ADIconButton(
      icon: Icons.share,
      iconSize: kButtonIconSizeLarge,
      tooltip: kLabelShare,
      color: Theme.of(context).colorScheme.primary,
      visualDensity: VisualDensity.compact,
      onPressed: onPressed,
    );
  }
}