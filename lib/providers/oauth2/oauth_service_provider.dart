import 'package:flutter_riverpod/flutter_riverpod.dart';

final oauthServiceProvider = Provider<OAuthService>((ref) {
  return OAuthService();
});