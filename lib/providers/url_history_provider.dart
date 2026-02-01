import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/services/hive_services.dart';

final urlHistoryProvider =
    StateNotifierProvider<UrlHistoryNotifier, List<Map<String, dynamic>>>(
  (ref) => UrlHistoryNotifier(hiveHandler),
);

class UrlHistoryNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final dynamic hiveHandler;

  UrlHistoryNotifier(this.hiveHandler)
      : super((hiveHandler as dynamic).getUrlHistory());

  void refresh() {
    state = (hiveHandler as dynamic).getUrlHistory();
  }
}
