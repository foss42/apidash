import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'response_details.dart';

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
    final sentRequestId = ref.watch(sentRequestIdStateProvider);
    final responseStatus = ref.watch(
        activeRequestModelProvider.select((value) => value?.responseStatus));
    final message =
        ref.watch(activeRequestModelProvider.select((value) => value?.message));
    if (sentRequestId != null && sentRequestId == activeId) {
      return const SendingWidget();
    }
    if (responseStatus == null) {
      return const NotSentWidget();
    }
    if (responseStatus == -1) {
      return ErrorMessage(message: '$message. $kUnexpectedRaiseIssue');
    }
    return const ResponseDetails();
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
    final color = Theme.of(context).colorScheme.secondary;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.north_east_rounded,
            size: 40,
            color: color,
          ),
          Text(
            'Not Sent',
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
