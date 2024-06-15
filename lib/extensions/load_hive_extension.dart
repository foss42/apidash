import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart';

/// Flutter extensions for Hive.
extension HiveWithFolder on HiveInterface {
  /// Initializes Hive with the path from [appDir].
  ///
  /// You can provide a [subDir] where the boxes should be stored.
  Future<void> initHiveWithRootFolder(String appDir, [String? subDir]) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (kIsWeb) return;

    init(join(appDir, subDir));
  }
}
