import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

const kHeaderRow = ["Header Name", "Header Value"];

class ResponseHeaders extends ConsumerStatefulWidget {
  const ResponseHeaders({super.key});

  @override
  ConsumerState<ResponseHeaders> createState() => _ResponseHeadersState();
}

class _ResponseHeadersState extends ConsumerState<ResponseHeaders> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final collection = ref.watch(collectionStateNotifierProvider)!;
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final requestHeaders =
        collection[idIdx].responseModel?.requestHeaders ?? {};
    final responseHeaders = collection[idIdx].responseModel?.headers ?? {};
    return Padding(
      padding: kPh20v5,
      child: ListView(
        children: [
          getHeaderBox(context, responseHeaders, "Response Headers"),
          if (responseHeaders.isNotEmpty) kVSpacer5,
          if (responseHeaders.isNotEmpty)
            MapTable(
              map: responseHeaders,
              colNames: kHeaderRow,
              firstColumnHeaderCase: true,
            ),
          kVSpacer10,
          getHeaderBox(context, requestHeaders, "Request Headers"),
          if (requestHeaders.isNotEmpty) kVSpacer5,
          if (requestHeaders.isNotEmpty)
            MapTable(
              map: requestHeaders,
              colNames: kHeaderRow,
              firstColumnHeaderCase: true,
            ),
        ],
      ),
    );
  }

  Widget getHeaderBox(BuildContext context, Map map, String name) {
    return SizedBox(
      height: kHeaderHeight,
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$name (${map.length} items)",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (map.isNotEmpty)
            CopyButton(
              toCopy: kEncoder.convert(map),
            ),
        ],
      ),
    );
  }
}
