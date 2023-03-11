import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/jsonview.dart';
import 'package:apidash/consts.dart';

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
    final collection = ref.watch(collectionStateNotifierProvider);
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final requestHeaders =
        collection[idIdx].responseModel?.requestHeaders ?? {};
    final responseHeaders = collection[idIdx].responseModel?.headers ?? {};
    return Container(
      decoration: tableContainerDecoration,
      margin: p5,
      child: ListView(
        children: [
          vspacer5,
          Row(
            children: [
              Expanded(
                child: Text(
                  "Request Headers (${requestHeaders.length} items)",
                  style: codeStyle,
                ),
              ),
              if (requestHeaders.isNotEmpty)
                TextButton(
                  onPressed: () async {
                    await Clipboard.setData(
                        ClipboardData(text: json.encode(requestHeaders)));
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.content_copy,
                        size: 20,
                      ),
                      Text("Copy")
                    ],
                  ),
                ),
            ],
          ),
          if (requestHeaders.isNotEmpty) vspacer5,
          if (requestHeaders.isNotEmpty)
            JsonView.map(
              requestHeaders,
              theme: jsonViewTheme,
            ),
          vspacer5,
          Row(
            children: [
              Expanded(
                child: Text(
                  "Response Headers (${responseHeaders.length} items)",
                  style: codeStyle,
                ),
              ),
              if (responseHeaders.isNotEmpty)
                TextButton(
                  onPressed: () async {
                    await Clipboard.setData(
                        ClipboardData(text: json.encode(responseHeaders)));
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.content_copy,
                        size: 20,
                      ),
                      Text("Copy")
                    ],
                  ),
                ),
            ],
          ),
          if (responseHeaders.isNotEmpty) vspacer5,
          if (responseHeaders.isNotEmpty)
            JsonView.map(
              responseHeaders,
              theme: jsonViewTheme,
            ),
        ],
      ),
    );
  }
}
