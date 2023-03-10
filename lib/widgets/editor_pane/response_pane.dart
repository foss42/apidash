import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import "../../consts.dart";
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
    final collection = ref.watch(collectionStateNotifierProvider);
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final responseStatus = collection[idIdx].responseStatus;
    final message = collection[idIdx].message;
    if (sentRequestId != null && sentRequestId == activeId) {
      return const SendingWidget();
    }
    if (responseStatus == null) {
      return const NotSentWidget();
    }
    if (responseStatus == -1) {
      return ErrorMessage(message: message);
    } else {
      return const ResponseViewer();
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

class SendingWidget extends StatelessWidget {
  const SendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              //Color.fromARGB(123, 71, 84, 179),
              color.withOpacity(0.7),
              BlendMode.dstIn,
            ),
            child: const Image(
              image: sendingIndicator,
              width: 300,
            ),
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
    final color = Theme.of(context).colorScheme.secondary;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_rounded,
            size: 40,
            color: color,
          ),
          Text(
            message ?? 'And error occurred.',
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
