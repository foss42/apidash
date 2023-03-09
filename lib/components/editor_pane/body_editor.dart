import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../styles.dart';
import '../../consts.dart';

class EditRequestBody extends StatefulWidget {
  const EditRequestBody({super.key});

  @override
  State<EditRequestBody> createState() => _EditRequestBodyState();
}

class _EditRequestBodyState extends State<EditRequestBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: tableContainerDecoration,
      margin: p5,
      child: Column(
        children: [
          Padding(
            padding: p10,
            child: Row(
              children: const [
                Text(
                  "Select Content Type:",
                  //style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 30,
                  child: DropdownButtonBodyContentType(),
                ),
              ],
            ),
          ),
          const Divider(),
          const Expanded(
            child: Padding(
              padding: p10,
              child: TextFieldEditor(),
            ),
          )
        ],
      ),
    );
  }
}

class DropdownButtonBodyContentType extends ConsumerStatefulWidget {
  const DropdownButtonBodyContentType({
    super.key,
  });

  @override
  ConsumerState<DropdownButtonBodyContentType> createState() =>
      _DropdownButtonBodyContentTypeState();
}

class _DropdownButtonBodyContentTypeState
    extends ConsumerState<DropdownButtonBodyContentType> {
  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeItemIdStateProvider);
    final collection = ref.read(collectionStateNotifierProvider);
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final requestBodyContentType = ref.watch(collectionStateNotifierProvider
        .select((value) => value[idIdx].requestBodyContentType));
    return DropdownButton<ContentType>(
      focusColor: colorGrey50,
      value: requestBodyContentType,
      icon: const Icon(
        Icons.unfold_more_rounded,
        size: 16,
      ),
      elevation: 4,
      style: codeStyle.copyWith(
          color: Theme.of(context)
              .colorScheme
              .primary), //Theme.of(context).textTheme.bodyMedium,
      underline: Container(
        height: 0,
      ),
      onChanged: (ContentType? value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId!, requestBodyContentType: value);
      },
      borderRadius: border12,
      items: ContentType.values
          .map<DropdownMenuItem<ContentType>>((ContentType value) {
        return DropdownMenuItem<ContentType>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              value.name,
              style: textStyleButton,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class TextFieldEditor extends ConsumerStatefulWidget {
  const TextFieldEditor({Key? key}) : super(key: key);

  @override
  ConsumerState<TextFieldEditor> createState() => _TextFieldEditorState();
}

class _TextFieldEditorState extends ConsumerState<TextFieldEditor> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeItemIdStateProvider);
    final reqestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(activeId!);
    return TextFormField(
      key: Key("$activeId-body"),
      initialValue: reqestModel.requestBody ?? "",
      onChanged: (value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId, requestBody: value);
      },
      style: codeStyle,
      decoration: InputDecoration(
        hintText: "Enter content (body)",
        hintStyle: codeStyle.copyWith(color: colorGrey500),
        border: InputBorder.none,
      ),
      keyboardType: TextInputType.multiline,
      expands: true,
      maxLines: null,
    );
  }
}
