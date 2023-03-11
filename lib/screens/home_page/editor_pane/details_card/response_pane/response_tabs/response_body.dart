import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/jsonview.dart';
import 'package:apidash/consts.dart';

class ResponseBody extends ConsumerStatefulWidget {
  const ResponseBody({super.key});

  @override
  ConsumerState<ResponseBody> createState() => _ResponseBodyState();
}

class _ResponseBodyState extends ConsumerState<ResponseBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final collection = ref.watch(collectionStateNotifierProvider);
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final responseModel = collection[idIdx].responseModel;
    var body = responseModel?.body ?? '';
    var contentType = responseModel?.contentType ?? "";
    return Padding(
      padding: p10,
      child: SingleChildScrollView(
        child: Column(
          children: [
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
            if (body.isNotEmpty && contentType.startsWith(JSON_MIMETYPE))
              JsonView.string(
                body,
                theme: jsonViewTheme,
              ),
            if (body.isNotEmpty && contentType.startsWith("text/")) Text(body),
          ],
        ),
      ),
    );
  }
}
