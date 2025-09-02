import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/dashbot_request_context.dart';

/// Default provider for Dashbot's external request context.
/// The host app should override this provider at the Dashbot subtree.
final dashbotRequestContextProvider = Provider<DashbotRequestContext?>(
  (ref) => null,
);