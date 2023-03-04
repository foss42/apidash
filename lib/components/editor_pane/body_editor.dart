import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../consts.dart';

class EditRequestBody extends StatefulWidget {
  const EditRequestBody({super.key});

  @override
  State<EditRequestBody> createState() => _EditRequestBodyState();
}

class _EditRequestBodyState extends State<EditRequestBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                child: DropdownButtonBodyContentType(),
                height: 30,
              )
            ],
          ),
        ),
        Expanded(
          child: TextFieldEditor(),
        )
      ],
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
      decoration: InputDecoration(
        hintText: "Enter body",
        hintStyle: TextStyle(color: Colors.grey.shade500),
        border: InputBorder.none,
      ),
      keyboardType: TextInputType.multiline,
      expands: true,
      maxLines: null,
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
    final reqestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(activeId!);
    return DropdownButton<ContentType>(
      focusColor: Colors.white,
      value: reqestModel.requestBodyContentType,
      icon: const Icon(
        Icons.unfold_more_rounded,
        size: 16,
      ),
      elevation: 4,
      underline: Container(
        height: 0,
        //color: Colors.deepPurpleAccent,
      ),
      onChanged: (ContentType? value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId!, requestBodyContentType: value);
      },
      borderRadius: BorderRadius.circular(10),
      items: ContentType.values
          .map<DropdownMenuItem<ContentType>>((ContentType value) {
        return DropdownMenuItem<ContentType>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              value.name,
            ),
          ),
        );
      }).toList(),
    );
  }
}
