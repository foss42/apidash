import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/update_service.dart';

final updateProvider = Provider((ref) => UpdateService());

final updateCheckProvider = FutureProvider.autoDispose((ref) async {
  final updateService = ref.watch(updateProvider);
  final updateInfo = await updateService.checkForUpdate();
  
  // Update the update available state
  if (updateInfo != null && updateInfo.isNotEmpty) {
    ref.read(updateAvailableProvider.notifier).state = true;
  }
  
  return updateInfo;
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

// Add a provider to track if an update is available
final updateAvailableProvider = StateProvider<bool>((ref) => false);
