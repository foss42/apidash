import 'package:apidash/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navRailIndexStateProvider = StateProvider<int>((ref) => 0);
final activeIdStateProvider = StateProvider<String?>((ref) => null);
final activeIdEditStateProvider = StateProvider<String?>((ref) => null);
final sentRequestIdStateProvider = StateProvider<String?>((ref) => null);
final codePaneVisibleStateProvider = StateProvider<bool>((ref) => false);
final saveDataStateProvider = StateProvider<bool>((ref) => false);
final clearDataStateProvider = StateProvider<bool>((ref) => false);
final codegenLanguageStateProvider =
    StateProvider<CodegenLanguage>((ref) => CodegenLanguage.dartHttp);
