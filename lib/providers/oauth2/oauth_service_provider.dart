import 'package:apidash/services/oauth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final oauthServiceProvider = Provider<OAuthService>((ref) {
  return OAuthService();
});