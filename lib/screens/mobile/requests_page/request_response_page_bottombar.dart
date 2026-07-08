import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home_page/editor_pane/url_card.dart';

class RequestResponsePageBottombar extends ConsumerWidget {
  const RequestResponsePageBottombar({
    super.key,
    required this.requestTabController,
  });
  final TabController requestTabController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 60 + MediaQuery.paddingOf(context).bottom,
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.onInverseSurface,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            ADFilledButton(
              onPressed: () {
                ref
                    .read(dashbotShowMobileProvider.notifier)
                    .update((state) => !state);
              },
              isTonal: true,
              items: [
                kHSpacer6,
                Text(
                  ref.watch(dashbotShowMobileProvider)
                      ? kLabelClose
                      : kLabelDashBot,
                  style: kTextStyleButton,
                ),
                kHSpacer6,
              ],
            ),
            const Spacer(),
            SizedBox(
              height: 36,
              child: SendRequestButton(
                onTap: () {
                  ref.read(dashbotShowMobileProvider.notifier).state = false;
                  if (requestTabController.index != 1) {
                    requestTabController.animateTo(1);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
