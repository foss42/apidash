import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/update_service.dart';

final updateProvider = Provider((ref) => UpdateService());

final updateCheckProvider = FutureProvider.autoDispose((ref) async {
  final updateService = ref.watch(updateProvider);
  return await updateService.checkForUpdate();
});

class UpdateNotifier extends StateNotifier<bool> {
  UpdateNotifier() : super(false);

  void setChecking(bool checking) {
    state = checking;
  }
}

final updateCheckingProvider = StateNotifierProvider<UpdateNotifier, bool>((ref) {
  return UpdateNotifier();
});
