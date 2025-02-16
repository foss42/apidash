import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../consts.dart';

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

    return ADIconButton(
      icon: Icons.share,
      iconSize: kButtonIconSizeLarge,
      tooltip: kLabelShare,
      color: Theme.of(context).colorScheme.primary,
      visualDensity: VisualDensity.compact,
      onPressed: () async {
        sm.hideCurrentSnackBar();
        try {
          await Share.share(toShare);
        } catch (e) {
          debugPrint("$e");
          sm.showSnackBar(getSnackBar(kMsgShareError));
        }
      },
    );
  }
}
