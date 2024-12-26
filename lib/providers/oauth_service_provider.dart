import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/oauth_service.dart';

final oauthServiceProvider = Provider<OAuthService>((ref) {
  return OAuthService();
});
