import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_parser/http_parser.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/utils/utils.dart';
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
    var mediaType = responseModel?.mediaType;
    if (responseModel == null) {
      return const ErrorMessage(
          message: 'Error: No Response Data Found. $kRaiseIssue');
    }
    if (mediaType == null) {
      return ErrorMessage(
          message:
              'Unknown Response content type - ${responseModel.contentType}. $kRaiseIssue');
    }
    return BodySuccess(
      mediaType: mediaType,
      responseModel: responseModel,
    );
  }
}

class BodySuccess extends StatefulWidget {
  const BodySuccess(
      {super.key, required this.mediaType, required this.responseModel});
  final MediaType mediaType;
  final ResponseModel responseModel;
  @override
  State<BodySuccess> createState() => _BodySuccessState();
}

class _BodySuccessState extends State<BodySuccess> {
  @override
  Widget build(BuildContext context) {
    String? body = widget.responseModel.body;
    if (body == null) {
      return Padding(
        padding: kP5,
        child: Text(
          '(empty)',
          style: kCodeStyle,
        ),
      );
    }
    var bytes = widget.responseModel.bodyBytes!;
    var responseBodyView = getResponseBodyViewOptions(widget.mediaType);
    print(responseBodyView);
    return Padding(
      padding: kPh20v5,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: kHeaderHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  responseBodyView.$0 == kDefaultBodyViewOptions
                      ? const SizedBox()
                      : ResponseBodyViewSelector(options: responseBodyView.$0),
                  CopyButton(toCopy: body),
                ],
              ),
            ),
            if (responseBodyView.$0.contains(ResponseBodyView.preview))
              Previewer(
                bytes: bytes,
                type: widget.mediaType.type,
                subtype: widget.mediaType.subtype,
              ),
            if (responseBodyView.$0.contains(ResponseBodyView.code))
              CodeHighlight(
                input: body,
                language: responseBodyView.$1,
                textStyle: kCodeStyle,
              ),
            if (responseBodyView.$0.contains(ResponseBodyView.raw))
              SelectableText(body),
          ],
        ),
      ),
    );
  }
}

class ResponseBodyViewSelector extends StatefulWidget {
  const ResponseBodyViewSelector({super.key, required this.options});

  final List<ResponseBodyView> options;
  @override
  State<ResponseBodyViewSelector> createState() =>
      _ResponseBodyViewSelectorState();
}

class _ResponseBodyViewSelectorState extends State<ResponseBodyViewSelector> {
  late ResponseBodyView value;

  @override
  void initState() {
    super.initState();
    value = widget.options[0];
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ResponseBodyView>(
      segments: widget.options
          .map<ButtonSegment<ResponseBodyView>>(
            (e) => ButtonSegment<ResponseBodyView>(
              value: e,
              label: Text(capitalizeFirstLetter(e.name)),
              icon: Icon(kResponseBodyViewIcons[e]),
            ),
          )
          .toList(),
      selected: {value},
      onSelectionChanged: (newSelection) {
        setState(() {
          value = newSelection.first;
        });
      },
    );
  }
}
