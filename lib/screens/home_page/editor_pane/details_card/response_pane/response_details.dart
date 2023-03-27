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
    final collection = ref.read(collectionStateNotifierProvider)!;
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final responseStatus = collection[idIdx].responseStatus;
    final message = collection[idIdx].message;
    final responseModel = collection[idIdx].responseModel;
    return Column(
      children: [
        Padding(
          padding: kPh20v10,
          child: SizedBox(
            height: kHeaderHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Response (",
                      ),
                      TextSpan(
                        text: "$responseStatus",
                        style: TextStyle(
                          color: getResponseStatusCodeColor(
                            responseStatus,
                            brightness: Theme.of(context).brightness,
                          ),
                          fontFamily: kCodeStyle.fontFamily,
                        ),
                      ),
                      const TextSpan(
                        text: ")",
                      ),
                    ],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                kHSpacer20,
                Expanded(
                  child: Text(
                    message ?? "",
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontFamily: kCodeStyle.fontFamily,
                          color: getResponseStatusCodeColor(
                            responseStatus,
                            brightness: Theme.of(context).brightness,
                          ),
                        ),
                  ),
                ),
                kHSpacer20,
                Text(
                  humanizeDuration(responseModel?.time),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontFamily: kCodeStyle.fontFamily,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
            ),
          ),
        ),
        const Expanded(
          child: ResponseTabs(),
        ),
      ],
    );
  }
}
