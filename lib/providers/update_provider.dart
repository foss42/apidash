import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/update_service.dart';

final updateProvider = Provider((ref) => UpdateService());

// Create a provider to handle the update checking process
final updateCheckProvider = FutureProvider.autoDispose((ref) async {
  final updateService = ref.watch(updateProvider);
  
  // Use the isolate-based implementation in UpdateService
  final updateInfo = await updateService.checkForUpdate();
  
  // Update the update available state if an update is available
  if (updateInfo != null && updateInfo.isNotEmpty) {
    // Use Future.microtask to avoid modifying state during initialization
    Future.microtask(() {
      ref.read(updateAvailableProvider.notifier).state = true;
    });
  }
  
  return updateInfo;
});

class UpdateNotifier extends StateNotifier<bool> {
  UpdateNotifier() : super(false);

  void setChecking(bool checking) {
    state = checking;
  }
}

// Provider to track if update checking is in progress
final updateCheckingProvider = StateNotifierProvider<UpdateNotifier, bool>((ref) {
  return UpdateNotifier();
});

// Provider to track if an update is available
final updateAvailableProvider = StateProvider<bool>((ref) => false);
