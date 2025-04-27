import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/consts.dart';
import 'package:apidash_design_system/apidash_design_system.dart';

/// Displays a list of headers with enabled/disabled status
class RequestHeadersCard extends StatelessWidget {
  final String title;
  final List<NameValueModel>? headers;
  final List<bool>? isEnabledList;

  const RequestHeadersCard({
    super.key, 
    required this.title, 
    this.headers, 
    this.isEnabledList,
  });

  @override
  Widget build(BuildContext context) {
    if (headers == null || headers!.isEmpty) return const SizedBox.shrink();

    return StyledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          kVSpacer8,
          ...List.generate(
            headers!.length,
            (i) => Padding(
              padding: kPv2,
              child: Row(
                children: [
                  Icon(
                    isEnabledList?[i] ?? true ? Icons.check_box : Icons.check_box_outline_blank,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  kHSpacer8,
                  Text(headers![i].name, style: const TextStyle(fontWeight: FontWeight.w500)),
                  kHSpacer8,
                  Text(
                    headers![i].value,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays a list of query parameters with enabled/disabled status
class RequestParamsCard extends StatelessWidget {
  final String title;
  final List<NameValueModel>? params;
  final List<bool>? isEnabledList;

  const RequestParamsCard({
    super.key, 
    required this.title, 
    this.params, 
    this.isEnabledList,
  });

  @override
  Widget build(BuildContext context) {
    if (params == null || params!.isEmpty) return const SizedBox.shrink();

    return StyledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          kVSpacer8,
          ...List.generate(
            params!.length,
            (i) => Padding(
              padding: kPv2,
              child: Row(
                children: [
                  Icon(
                    isEnabledList?[i] ?? true ? Icons.check_box : Icons.check_box_outline_blank,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  kHSpacer8,
                  Text(params![i].name, style: const TextStyle(fontWeight: FontWeight.w500)),
                  kHSpacer8,
                  Text(
                    params![i].value,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays the request body with an optional content type label
class RequestBodyCard extends StatelessWidget {
  final String title;
  final String? body;
  final String? contentType;
  final bool showCopyButton;

  const RequestBodyCard({
    super.key,
    required this.title,
    this.body,
    this.contentType,
    this.showCopyButton = false,
  });

  @override
  Widget build(BuildContext context) {
    if (body == null || body!.isEmpty) return const SizedBox.shrink();

    return StyledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              kHSpacer8,
              if (contentType != null)
                Chip(
                  label: Text(
                    contentType!,
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          kVSpacer8,
          Container(
            width: double.infinity,
            padding: kP12,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: kBorderRadius12,
            ),
            child: Text(
              body!,
              style: kCodeStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

/// A reusable card widget with consistent styling
class StyledCard extends StatelessWidget {
  final Widget child;

  const StyledCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.surfaceContainerHighest),
        borderRadius: kBorderRadius12,
      ),
      child: Padding(padding: kP12, child: child), // Changed from kP16 to kP12
    );
  }
}

/// Displays the response body along with summary information (status, message, time)
class ResponseBodyCard extends StatelessWidget {
  final HttpResponseModel? httpResponseModel;
  final int? responseStatus;
  final String? message;
  final String? body;

  const ResponseBodyCard({
    super.key,
    this.httpResponseModel,
    this.responseStatus,
    this.message,
    this.body,
  });

  Color _getStatusColor(int? status) {
    if (status == null) return kColorStatusCodeDefault;
    if (status >= 200 && status < 300) return kColorStatusCode200;
    if (status >= 300 && status < 400) return kColorStatusCode300;
    if (status >= 400 && status < 500) return kColorStatusCode400;
    return kColorStatusCode500;
  }

  @override
  Widget build(BuildContext context) {
    final statusCode = httpResponseModel?.statusCode ?? responseStatus;
    final responseTime = httpResponseModel?.time?.inMilliseconds ?? 0;
    final responseBody = body ?? httpResponseModel?.formattedBody ?? httpResponseModel?.body ?? '';
    final statusReason = statusCode != null ? kResponseCodeReasons[statusCode] ?? 'Unknown' : null;

    // Hide the card if there's no relevant data to display
    if (statusCode == null && responseBody.isEmpty && (message == null || message!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return StyledCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(kLabelResponseBody, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              kHSpacer8,
              if (statusCode != null)
                Chip(
                  label: Text('$statusCode${statusReason != null ? ' - $statusReason' : ''}', 
                    style: const TextStyle(fontSize: 12, color: kColorWhite)),
                  backgroundColor: _getStatusColor(statusCode),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              const Spacer(),
              if (responseTime > 0)
                Text('${responseTime}ms', style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))
                ),
            ],
          ),
          if (message != null && message!.isEmpty) kVSpacer8,
          if (message != null && message!.isNotEmpty) ...[
            kVSpacer8,
            Text(message!, style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))
            ),
          ],
          if (responseBody.isNotEmpty) ...[
            kVSpacer10, // Changed from kVSpacer12 to kVSpacer10
            Container(
              width: double.infinity,
              padding: kP12,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                borderRadius: kBorderRadius12,
              ),
              child: Text(
                responseBody,
                style: kCodeStyle.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ),
          ],
        ],
      ),
    );
  }
}