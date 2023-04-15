import 'package:apidash/services/hive_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeStateNotifier extends StateNotifier<bool> {
  ThemeStateNotifier(this.hiveHandler) : super(false) {
    state = hiveHandler.getDarkMode() ?? false;
  }
  final HiveHandler hiveHandler;

  Future<void> toggle() async {
    state = !state;
    await hiveHandler.setDarkMode(state);
  }
}
