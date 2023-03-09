import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import '../../providers/providers.dart';
import '../../models/request_model.dart';
import '../styles.dart';
import "../../utils/utils.dart";
import "../../consts.dart";

class ResponsePane extends ConsumerStatefulWidget {
  const ResponsePane({super.key});

  @override
  ConsumerState<ResponsePane> createState() => _ResponsePaneState();
}

class _ResponsePaneState extends ConsumerState<ResponsePane> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final collection = ref.read(collectionStateNotifierProvider);
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final status = ref.watch(collectionStateNotifierProvider
        .select((value) => (value[idIdx].responseStatus,
                            value[idIdx].message,
                            value[idIdx].responseModel)));
    if (status.$0 == null) {
      return const NotSentWidget();
    }
    if (status.$0 == -1) {
      return ErrorMessage(message: status.$1);
    }
    else{
      //var responseModel = ref
      //                    .read(collectionStateNotifierProvider.notifier)
      //                    .getRequestModel(activeId!)
      //                    .responseModel;
      return ResponseViewer(statusCode: status.$0!, 
                            message: status.$1, 
                            responseModel: status.$2!);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class NotSentWidget extends StatelessWidget {
  const NotSentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.north_east_rounded,
            size: 40,
            color: colorErrorMsg,
          ),
          Text(
            'Not Sent',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: colorErrorMsg),
          ),
        ],
      ),
    );
  }
}

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_rounded,
            size: 40,
            color: colorErrorMsg,
          ),
          Text(
            message ?? 'And error occurred.',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: colorErrorMsg),
          ),
        ],
      ),
    );
  }
}

final jsonViewTheme = JsonViewTheme(defaultTextStyle : codeStyle,
                                    viewType: JsonViewType.collapsible,
                                    backgroundColor: colorBg,
                                    stringStyle: const TextStyle(color: Colors.brown),
                                    closeIcon: const Icon(
                                      Icons.arrow_drop_up,
                                      size: 18,
                                    ),
                                    openIcon : const Icon(
                                      Icons.arrow_drop_down,
                                      size: 18,
                                    ),
      );

class ResponseViewer extends StatelessWidget {
  final int statusCode;
  final String? message;
  final ResponseModel responseModel;

  const ResponseViewer({
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
                  width:50,
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
                  width:100,
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
                if(requestHeaders.isNotEmpty) TextButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: json.encode(requestHeaders)));
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
            if(requestHeaders.isNotEmpty) const SizedBox(height: 5),
            if(requestHeaders.isNotEmpty) JsonView.map(
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
                if(responseHeaders.isNotEmpty) TextButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: json.encode(responseHeaders)));
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
            if(responseHeaders.isNotEmpty) const SizedBox(height: 5),
            if(responseHeaders.isNotEmpty) JsonView.map(
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
                if(body.isNotEmpty) TextButton(
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
            if(body.isNotEmpty && responseModel.contentType!.startsWith(JSON_MIMETYPE)) 
              JsonView.string(
                body,
                theme: jsonViewTheme,
              ),
            if(body.isNotEmpty && responseModel.contentType!.startsWith("text/"))
              Text(body), 
          ],
        ),
      ),
    );
  }
}
