import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

final jsonViewTheme = JsonViewTheme(
  defaultTextStyle: codeStyle,
  viewType: JsonViewType.collapsible,
  backgroundColor: colorBg,
  stringStyle: const TextStyle(color: Colors.brown),
  closeIcon: const Icon(
    Icons.arrow_drop_up,
    size: 18,
  ),
  openIcon: const Icon(
    Icons.arrow_drop_down,
    size: 18,
  ),
);

class ResponseViewer extends ConsumerStatefulWidget {
  const ResponseViewer({super.key});

  @override
  ConsumerState<ResponseViewer> createState() => _ResponseViewerState();
}

class _ResponseViewerState extends ConsumerState<ResponseViewer> {
  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final sentRequestId = ref.watch(sentRequestIdStateProvider);
    final collection = ref.watch(collectionStateNotifierProvider);
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final responseStatus = collection[idIdx].responseStatus;
    final message = collection[idIdx].message;
    return Container();
  }
}

class ResponseiViewer extends StatelessWidget {
  final int statusCode;
  final String? message;
  final ResponseModel responseModel;

  const ResponseiViewer({
    super.key,
    required this.statusCode,
    required this.message,
    required this.responseModel,
  });

  @override
  Widget build(BuildContext context) {
    var requestHeaders = responseModel.requestHeaders ?? {};
    var responseHeaders = responseModel.headers ?? {};
    var body = responseModel.body ?? '';
    return Padding(
      padding: p10,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: const [
                Text(
                  "Response",
                  style: textStyleButton,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Text(
                    statusCode.toString(),
                    style: codeStyle.copyWith(
                      color: getResponseStatusCodeColor(statusCode),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    message ?? "",
                    style: codeStyle.copyWith(
                      color: getResponseStatusCodeColor(statusCode),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    humanizeDuration(responseModel.time),
                    style: codeStyle.copyWith(
                      color: getResponseStatusCodeColor(statusCode),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
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
            if (requestHeaders.isNotEmpty) const SizedBox(height: 5),
            if (requestHeaders.isNotEmpty)
              JsonView.map(
                requestHeaders,
                theme: jsonViewTheme,
              ),
            const SizedBox(height: 5),
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
            if (responseHeaders.isNotEmpty) const SizedBox(height: 5),
            if (responseHeaders.isNotEmpty)
              JsonView.map(
                responseHeaders,
                theme: jsonViewTheme,
              ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Body ${body.isEmpty ? '(empty)' : ''}",
                    style: codeStyle,
                  ),
                ),
                if (body.isNotEmpty)
                  TextButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: body));
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
            const SizedBox(height: 5),
            if (body.isNotEmpty &&
                responseModel.contentType!.startsWith(JSON_MIMETYPE))
              JsonView.string(
                body,
                theme: jsonViewTheme,
              ),
            if (body.isNotEmpty &&
                responseModel.contentType!.startsWith("text/"))
              Text(body),
          ],
        ),
      ),
    );
  }
}
