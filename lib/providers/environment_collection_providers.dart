import 'package:apidash/models/environments_model.dart';
import 'package:apidash/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final environmentCollectionStateNotifierProvider = StateNotifierProvider<
    EnvironmentCollectionStateNotifier, EnvironmentsModel?>((ref) {
  return EnvironmentCollectionStateNotifier(ref);
});

class EnvironmentCollectionStateNotifier
    extends StateNotifier<EnvironmentsModel?> {
  final Ref ref;

  EnvironmentCollectionStateNotifier(this.ref) : super(null) {
    state = EnvironmentsModel(
      activeEnvironmentId: uuid.v1(),
      environments: [
        EnvironmentModel(
          isActive: true,
          id: uuid.v1(),
          name: "Globals",
          variables: [
            EnvironmentVariableModel(
              id: uuid.v1(),
              variable: "baseUrl",
              value: "http://localhost:8080",
            )
          ],
        )
      ],
    );
  }
}
