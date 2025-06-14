import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import '../common_widgets/common_widgets.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart'; 

class DescriptionPane extends StatelessWidget {
  final RequestModel? selectedRequest;

  const DescriptionPane({super.key, this.selectedRequest});

  @override
  Widget build(BuildContext context) {
    final httpRequestModel = selectedRequest?.httpRequestModel;
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SingleChildScrollView(
        padding: kP12, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedRequest?.name != null) ...[
              Text(selectedRequest!.name, 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              if (selectedRequest?.description != null)
                Text(selectedRequest!.description, style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
              kVSpacer16,
            ],
            UrlCard(
              requestModel: selectedRequest,
            ),
            kVSpacer16,
            RequestHeadersCard(
              title: kLabelHeaders,
              headers: httpRequestModel?.headers,
              isEnabledList: httpRequestModel?.isHeaderEnabledList,
            ),
            kVSpacer10,
            RequestParamsCard(
              title: kLabelQuery,
              params: httpRequestModel?.params,
              isEnabledList: httpRequestModel?.isParamEnabledList,
            ),
            kVSpacer10,
            RequestBodyCard(
              title: kLabelBody,
              body: httpRequestModel?.body,
              contentType: httpRequestModel?.bodyContentType?.toString().split('.').last,
            ),
            kVSpacer16,
            ResponseBodyCard(
              httpResponseModel: selectedRequest?.httpResponseModel,
              responseStatus: selectedRequest?.responseStatus,
              message: selectedRequest?.message,
              body: selectedRequest?.httpResponseModel?.formattedBody ?? selectedRequest?.httpResponseModel?.body,
            ),
          ],
        ),
      ),
    );
  }
}