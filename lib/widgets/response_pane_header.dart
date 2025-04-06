import 'dart:convert';

import 'package:apidash/apitoolgen/request_consolidator.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/services/agentic_services/agent_caller.dart';
import 'package:apidash/widgets/ai_ui_desginer_widgets.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'button_clear_response.dart';

class ResponsePaneHeader extends ConsumerWidget {
  const ResponsePaneHeader({
    super.key,
    this.responseStatus,
    this.message,
    this.time,
    this.onClearResponse,
  });

  final int? responseStatus;
  final String? message;
  final Duration? time;
  final VoidCallback? onClearResponse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showClearButton = onClearResponse != null;
    return Padding(
      padding: kPv8,
      child: SizedBox(
        // height: kHeaderHeight,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                kHSpacer10,
                Expanded(
                  child: Text(
                    "$responseStatus: ${message ?? '-'}",
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: kCodeStyle.fontFamily,
                          color: getResponseStatusCodeColor(
                            responseStatus,
                            brightness: Theme.of(context).brightness,
                          ),
                        ),
                  ),
                ),
                kHSpacer10,
                Text(
                  humanizeDuration(time),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: kCodeStyle.fontFamily,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                kHSpacer10,
                showClearButton
                    ? ClearResponseButton(
                        onPressed: onClearResponse,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    padding: kPh12,
                    minimumSize: const Size(44, 44),
                  ),
                  onPressed: () async {
                    final requestModel = ref.watch(selectedRequestModelProvider
                        .select((value) => value?.httpRequestModel));
                    final responseModel = ref.watch(selectedRequestModelProvider
                        .select((value) => value?.httpResponseModel));

                    if (requestModel == null) return;
                    if (responseModel == null) {
                      print("AA");
                      return;
                    }
                    String? bodyTXT;
                    Map? bodyJSON;
                    List<Map>? bodyFormData;

                    if (requestModel.bodyContentType == ContentType.formdata) {
                      bodyFormData = requestModel.formDataMapList;
                    } else if (requestModel.bodyContentType ==
                        ContentType.json) {
                      bodyJSON = jsonDecode(requestModel.body.toString());
                    } else {
                      bodyTXT = requestModel.body!;
                    }

                    final reqDesModel = APIDashRequestDescription(
                      endpoint: requestModel.url,
                      method: requestModel.method.name.toUpperCase(),
                      responseType: responseModel.contentType.toString(),
                      headers: requestModel.headersMap,
                      response: responseModel.body,
                      formData: bodyFormData,
                      bodyTXT: bodyTXT,
                      bodyJSON: bodyJSON,
                    );

                    print(reqDesModel.generateREQDATA);
                    return;

                    final x = await APIDashAgentCaller.instance
                        .apiToolFunctionGenerator(
                      ref,
                      input: AgentInputs(variables: {
                        'REQDATA': reqDesModel.generateREQDATA,
                        'TARGET_LANGUAGE': 'JAVASCRIPT'
                      }),
                    );

                    print(x);

                    // print(reqDesModel.generateREQDATA);

                    // final model = ref.watch(selectedRequestModelProvider
                    //     .select((value) => value?.httpResponseModel));
                    // showCustomDialog(context, model?.formattedBody ?? "");
                  },
                  icon: Icon(
                    Icons.token_outlined,
                  ),
                  label: const SizedBox(
                    child: Text(
                      "Generate Tool",
                    ),
                  ),
                ),
                kHSpacer10,
                FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    padding: kPh12,
                    minimumSize: const Size(44, 44),
                  ),
                  onPressed: () {
                    final model = ref.watch(selectedRequestModelProvider
                        .select((value) => value?.httpResponseModel));
                    showCustomDialog(context, model?.formattedBody ?? "");
                  },
                  icon: Icon(
                    Icons.generating_tokens,
                  ),
                  label: const SizedBox(
                    child: Text(
                      kLabelGenerateUI,
                    ),
                  ),
                ),
                kHSpacer10,
              ],
            )
          ],
        ),
      ),
    );
  }
}
