/// Rate limiter for OAuth2 authentication attempts
/// Implements exponential backoff to prevent abuse and brute force attacks
class OAuth2RateLimiter {
  static final Map<String, _RateLimitState> _states = {};
  
  // Maximum attempts before lockout
  static const int _maxAttempts = 5;
  
  // Initial delay after first failure (in seconds)
  static const int _initialDelay = 2;
  
  // Maximum delay (in seconds)
  static const int _maxDelay = 300; // 5 minutes
  
  // Time window for reset (in minutes)
  static const int _resetWindow = 30;

  /// Check if an OAuth operation can proceed
  /// Returns null if allowed, or DateTime when the operation can be retried
  static DateTime? canProceed(String key) {
    final state = _states[key];
    
    if (state == null) {
      // First attempt, no restrictions
      return null;
    }
    
    final now = DateTime.now();
    
    // Check if we should reset the counter (time window passed)
    if (now.difference(state.firstAttempt).inMinutes >= _resetWindow) {
      _states.remove(key);
      return null;
    }
    
    // Check if we're in cooldown period
    if (state.nextAttemptAt != null && now.isBefore(state.nextAttemptAt!)) {
      return state.nextAttemptAt;
    }
    
    // Check if max attempts exceeded
    if (state.attemptCount >= _maxAttempts) {
      // Calculate next allowed attempt with exponential backoff
      final delaySeconds = _calculateDelay(state.attemptCount);
      final nextAttempt = state.lastAttempt.add(Duration(seconds: delaySeconds));
      
      if (now.isBefore(nextAttempt)) {
        return nextAttempt;
      }
    }
    
    return null;
  }

  /// Record a failed authentication attempt
  static void recordFailure(String key) {
    final now = DateTime.now();
    final state = _states[key];
    
    if (state == null) {
      _states[key] = _RateLimitState(
        firstAttempt: now,
        lastAttempt: now,
        attemptCount: 1,
        nextAttemptAt: null,
      );
    } else {
      final delaySeconds = _calculateDelay(state.attemptCount + 1);
      
      _states[key] = _RateLimitState(
        firstAttempt: state.firstAttempt,
        lastAttempt: now,
        attemptCount: state.attemptCount + 1,
        nextAttemptAt: now.add(Duration(seconds: delaySeconds)),
      );
    }
  }

  /// Record a successful authentication (clears the rate limit)
  static void recordSuccess(String key) {
    _states.remove(key);
  }

  /// Calculate delay with exponential backoff
  static int _calculateDelay(int attemptCount) {
    if (attemptCount <= 1) return 0;
    
    // Exponential backoff: 2^(n-1) seconds, capped at _maxDelay
    final delay = _initialDelay * (1 << (attemptCount - 2));
    return delay > _maxDelay ? _maxDelay : delay;
  }

  /// Generate rate limit key from client credentials
  static String generateKey(String clientId, String tokenUrl) {
    return '$clientId:$tokenUrl';
  }

  /// Get remaining cooldown time in seconds
  static int? getCooldownSeconds(String key) {
    final canProceedAt = canProceed(key);
    if (canProceedAt == null) return null;
    
    final now = DateTime.now();
    final diff = canProceedAt.difference(now);
    return diff.inSeconds > 0 ? diff.inSeconds : null;
  }

  /// Clear all rate limiting states (for testing or admin purposes)
  static void clearAll() {
    _states.clear();
  }
}

class _RateLimitState {
  final DateTime firstAttempt;
  final DateTime lastAttempt;
  final int attemptCount;
  final DateTime? nextAttemptAt;

  _RateLimitState({
    required this.firstAttempt,
    required this.lastAttempt,
    required this.attemptCount,
    this.nextAttemptAt,
  });
}
