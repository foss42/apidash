import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'history_details.dart';
import 'history_requests.dart';

class HistoryViewer extends StatelessWidget {
  const HistoryViewer({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.isMediumWindow) {
      return const HistoryDetails();
    }
    return Padding(
      padding: kIsMacOS || kIsWindows ? kPt28o8 : kP8,
      child: Card(
        color: kColorTransparent,
        surfaceTintColor: kColorTransparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          borderRadius: kBorderRadius12,
        ),
        elevation: 0,
        child: const HistorySplitView(
          sidebarWidget: HistoryRequests(),
          mainWidget: HistoryDetails(),
        ),
      ),
    );
  }
}
