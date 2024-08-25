import 'dart:io';

import 'desktop/env_manager_test.dart';
import 'desktop/his_request_test.dart';
import 'desktop/req_editor_test.dart';
import 'mobile/env_manager_test.dart';
import 'mobile/his_request_test.dart';
import 'mobile/req_editor_test.dart';

Future<void> main() async {
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    await runDesktopReqIntegrationTest();
    await runDesktopEnvIntegrationTest();
    await runDesktopHisIntegrationTest();
  } else if (Platform.isAndroid || Platform.isIOS) {
    await runMobileReqIntegrationTest();
    await runMobileEnvIntegrationTest();
    await runMobileHisIntegrationTest();
  } else {
    throw Exception("Unsupported Platform");
  }
}
