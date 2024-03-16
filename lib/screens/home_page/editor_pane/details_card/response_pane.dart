// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:apidash/providers/providers.dart';
// import 'package:apidash/widgets/widgets.dart';
// import 'package:apidash/consts.dart';

// class ResponsePane extends ConsumerWidget {
//   const ResponsePane({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isWorking = ref.watch(
//             selectedRequestModelProvider.select((value) => value?.isWorking)) ??
//         false;
//     final responseStatus = ref.watch(
//         selectedRequestModelProvider.select((value) => value?.responseStatus));
//     final message = ref
//         .watch(selectedRequestModelProvider.select((value) => value?.message));
//     if (isWorking) {
//       return const SendingWidget();
//     }
//     if (responseStatus == null) {
//       return const NotSentWidget();
//     }
//     if (responseStatus == -1) {
//       return ErrorMessage(message: '$message. $kUnexpectedRaiseIssue');
//     }
//     return const ResponseDetails();
//   }
// }

// class ResponseDetails extends ConsumerWidget {
//   const ResponseDetails({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final responseStatus = ref.watch(
//         selectedRequestModelProvider.select((value) => value?.responseStatus));
//     final message = ref
//         .watch(selectedRequestModelProvider.select((value) => value?.message));
//     final responseModel = ref.watch(
//         selectedRequestModelProvider.select((value) => value?.responseModel));
//     return Column(
//       children: [
//         ResponsePaneHeader(
//           responseStatus: responseStatus,
//           message: message,
//           time: responseModel?.time,
//         ),
//         const Expanded(
//           child: ResponseTabs(),
//         ),
//       ],
//     );
//   }
// }

// class ResponseTabs extends ConsumerWidget {
//   const ResponseTabs({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedId = ref.watch(selectedIdStateProvider);
//     return ResponseTabView(
//       selectedId: selectedId,
//       children: const [
//         ResponseBodyTab(),
//         ResponseHeadersTab(),
//       ],
//     );
//   }
// }

// class ResponseBodyTab extends ConsumerWidget {
//   const ResponseBodyTab({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedRequestModel = ref.watch(selectedRequestModelProvider);
//     return ResponseBody(
//       selectedRequestModel: selectedRequestModel,
//     );
//   }
// }

// class ResponseHeadersTab extends ConsumerWidget {
//   const ResponseHeadersTab({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final requestHeaders = ref.watch(selectedRequestModelProvider
//             .select((value) => value?.responseModel?.requestHeaders)) ??
//         {};
//     final responseHeaders = ref.watch(selectedRequestModelProvider
//             .select((value) => value?.responseModel?.headers)) ??
//         {};
//     return ResponseHeaders(
//       responseHeaders: responseHeaders,
//       requestHeaders: requestHeaders,
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class ResponsePane extends ConsumerWidget {
  const ResponsePane({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWorking = ref.watch(
            selectedRequestModelProvider.select((value) => value?.isWorking)) ??
        false;
    final responseStatus = ref.watch(
        selectedRequestModelProvider.select((value) => value?.responseStatus));
    final message = ref
        .watch(selectedRequestModelProvider.select((value) => value?.message));
    final settings = ref.watch(settingsProvider);

    print(responseStatus);
    final stopwatch = Stopwatch(); // Create a stopwatch instance
    Timer? timer;
    bool timerexpired = true;
    if (responseStatus == null) timerexpired = false;
    if (responseStatus == -2) {
      timer?.cancel();
      stopwatch.stop();
      return ErrorMessage(message: "ConnectionTimeOutExpired");
    }
    if (isWorking) {
      stopwatch.start();
      timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
        final elapsedTime = stopwatch.elapsedMilliseconds;
        if (settings.connectionTimeout != null &&
            elapsedTime >= settings.connectionTimeout!) {
          timerexpired = true;
          print(elapsedTime);
          print("connectionTime: ${settings.connectionTimeout}");
          print("entered");
          timer.cancel();
          stopwatch.stop();
          ref.read(selectedRequestModelProvider.notifier).update((state) {
            return state?.copyWith(responseStatus: -2);
          });
          return;
        }
      });
      return const SendingWidget();
    }
    stopwatch.stop();
    print(timerexpired);
    if (responseStatus == 200 && timerexpired == false) {
      return const ResponseDetails();
    }
    else if (responseStatus == -1) {
      return ErrorMessage(message: '$message. $kUnexpectedRaiseIssue');
    }
    else if (responseStatus == -2) {
      return ErrorMessage(message: "ConnectionTimeOutExpired");
    }
    return const NotSentWidget();
  }
}

class ResponseDetails extends ConsumerWidget {
  const ResponseDetails({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responseStatus = ref.watch(
        selectedRequestModelProvider.select((value) => value?.responseStatus));
    final message = ref
        .watch(selectedRequestModelProvider.select((value) => value?.message));
    final responseModel = ref.watch(
        selectedRequestModelProvider.select((value) => value?.responseModel));
    return Column(
      children: [
        ResponsePaneHeader(
          responseStatus: responseStatus,
          message: message,
          time: responseModel?.time,
        ),
        const Expanded(
          child: ResponseTabs(),
        ),
      ],
    );
  }
}

class ResponseTabs extends ConsumerWidget {
  const ResponseTabs({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    return ResponseTabView(
      selectedId: selectedId,
      children: const [
        ResponseBodyTab(),
        ResponseHeadersTab(),
      ],
    );
  }
}

class ResponseBodyTab extends ConsumerWidget {
  const ResponseBodyTab({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRequestModel = ref.watch(selectedRequestModelProvider);
    return ResponseBody(
      selectedRequestModel: selectedRequestModel,
    );
  }
}

class ResponseHeadersTab extends ConsumerWidget {
  const ResponseHeadersTab({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestHeaders = ref.watch(selectedRequestModelProvider
            .select((value) => value?.responseModel?.requestHeaders)) ??
        {};
    final responseHeaders = ref.watch(selectedRequestModelProvider
            .select((value) => value?.responseModel?.headers)) ??
        {};
    return ResponseHeaders(
      responseHeaders: responseHeaders,
      requestHeaders: requestHeaders,
    );
  }
}
