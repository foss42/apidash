import 'package:apidash/dashbot/core/model/dashbot_window_model.dart';
import 'package:apidash/dashbot/core/providers/dashbot_window_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  test(
      'given dashbot window model when instatiated then initial values must match the default values',
      () {
    final container = createContainer();

    final initialState = container.read(dashbotWindowNotifierProvider);

    expect(initialState, const DashbotWindowModel());
    expect(initialState.width, 350);
    expect(initialState.height, 450);
    expect(initialState.right, 50);
    expect(initialState.bottom, 100);
    expect(initialState.isActive, false);
  });
}
