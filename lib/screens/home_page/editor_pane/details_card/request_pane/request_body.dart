import 'package:apidash/widgets/dropdown_websocket_content_type.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'request_form_data.dart';

class EditRequestBody extends ConsumerWidget {
  const EditRequestBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!);
    final contentType = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.bodyContentType));
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
    final darkMode = ref.watch(settingsProvider.select(
      (value) => value.isDark,
    ));

    return Column(
      children: [
        switch(apiType){
        APIType.rest => const SizedBox(
                height: kHeaderHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Select Content Type:",
                    ),
                    DropdownButtonBodyContentType(),
                  ],
                ),
        ),
        APIType.webSocket => //dont forget to make it switch and put for rest
             SizedBox(
                height: kHeaderHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding:EdgeInsets.only(left:10),
                      child: SizedBox(
                          height: kHeaderHeight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                  Text(
                                    "Select Content Type:",
                                  ),
                                  DropdownButtonBodyContentWebSocketType(),
                            ]),),
                     ),
                    
                    
                    Padding(
                      padding:const EdgeInsets.only(right:10),
                      child: SendButton(isWorking: false, onTap: (){
                          ref.read(collectionStateNotifierProvider.notifier).sendFrames();
                        }),
                      
                    ),
                  ],
                ),
              ),
         _=> kSizedBoxEmpty,
            
        },
        switch (apiType) {
          APIType.rest => Expanded(
              child: switch (contentType) {
                ContentType.formdata =>
                  const Padding(padding: kPh4, child: FormDataWidget()),
                ContentType.json => Padding(
                    padding: kPt5o10,
                    child: JsonTextFieldEditor(
                      key: Key("$selectedId-json-body"),
                      fieldKey: "$selectedId-json-body-editor-$darkMode",
                      isDark: darkMode,
                      initialValue: requestModel?.httpRequestModel?.body,
                      onChanged: (String value) {
                        ref
                            .read(collectionStateNotifierProvider.notifier)
                            .update(body: value);
                      },
                      hintText: kHintJson,
                    ),
                  ),
                _ => Padding(
                    padding: kPt5o10,
                    child: TextFieldEditor(
                      key: Key("$selectedId-body"),
                      fieldKey: "$selectedId-body-editor",
                      initialValue: requestModel?.httpRequestModel?.body,
                      onChanged: (String value) {
                        ref
                            .read(collectionStateNotifierProvider.notifier)
                            .update(body: value);
                      },
                      hintText: kHintText,
                    ),
                  ),
              },
            ),
          APIType.graphql => Expanded(
              child: Padding(
                padding: kPt5o10,
                child: TextFieldEditor(
                  key: Key("$selectedId-query"),
                  fieldKey: "$selectedId-query-editor",
                  initialValue: requestModel?.httpRequestModel?.query,
                  onChanged: (String value) {
                    ref
                        .read(collectionStateNotifierProvider.notifier)
                        .update(query: value);
                  },
                  hintText: kHintQuery,
                ),
              ),
            ),
          APIType.webSocket => Expanded(
            
              child: Padding(
                padding: kPt5o10,
                child: Stack(
                  children: [
                  TextFieldEditor(
                    key: Key("$selectedId-websocket-body"),
                    fieldKey: "$selectedId-websocket-body-editor",
                   initialValue: requestModel?.webSocketRequestModel?.message,
                    onChanged: (String value) {
                    ref
                      .read(collectionStateNotifierProvider.notifier)
                      .update(webSocketMessage: value);
                    },
                    hintText: kHintMessage,
                  ),
  
                  ],
                 
              ),
              ),
            ),
          _ => kSizedBoxEmpty,
        }
      ],
    );
  }
}

class DropdownButtonBodyContentType extends ConsumerWidget {
  const DropdownButtonBodyContentType({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final requestBodyContentType = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.bodyContentType));
    return DropdownButtonContentType(
      contentType: requestBodyContentType,
      onChanged: (ContentType? value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(bodyContentType: value);
      },
    );
  }
}

class DropdownButtonBodyContentWebSocketType extends ConsumerWidget {
  const DropdownButtonBodyContentWebSocketType({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final requestBodyContentType = ref.watch(selectedRequestModelProvider
        .select((value) => value?.webSocketRequestModel?.contentType));
    return DropdownButtonContentTypeWebSocket(
      contentType: requestBodyContentType,
      onChanged: (ContentTypeWebSocket? value) {
        
        // ref.read(collectionStateNotifierProvider.notifier).update(
        //   contentType: value,
        // );
      
      },
    );
  }
}
