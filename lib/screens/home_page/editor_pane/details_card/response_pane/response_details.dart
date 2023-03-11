import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import 'response_tabs/response_tabs.dart';

class ResponseDetails extends ConsumerStatefulWidget {
  const ResponseDetails({super.key});

  @override
  ConsumerState<ResponseDetails> createState() => _ResponseDetailsState();
}

class _ResponseDetailsState extends ConsumerState<ResponseDetails> {
  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final collection = ref.read(collectionStateNotifierProvider);
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final responseStatus = collection[idIdx].responseStatus;
    final message = collection[idIdx].message;
    final responseModel = collection[idIdx].responseModel;
    return Column(
      children: [
        Row(
          children: const [
            Text(
              "Response",
              style: kTextStyleButton,
            ),
          ],
        ),
        kVSpacer5,
        Row(
          children: [
            SizedBox(
              width: kHeaderHeight,
              child: Text(
                "$responseStatus",
                style: kCodeStyle.copyWith(
                  color: getResponseStatusCodeColor(responseStatus),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                message ?? "",
                style: kCodeStyle.copyWith(
                  color: getResponseStatusCodeColor(responseStatus),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                humanizeDuration(responseModel!.time),
                style: kCodeStyle.copyWith(
                  color: getResponseStatusCodeColor(responseStatus),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const Expanded(
          child: ResponseTabs(),
        ),
      ],
    );
  }
}
