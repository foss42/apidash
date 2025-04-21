/// Constants related to stress testing API endpoints
class StressTestConstants {
  // Timeout constants
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration isolateCommunicationTimeout = Duration(seconds: 10);
  static const Duration gracePeriodTimeout = Duration(seconds: 5);
  
  // Error codes
  static const int errorStatusCode = -1;
  
  // Status codes
  static const int successMinStatusCode = 200;
  static const int successMaxStatusCode = 299;
  
  // Default values
  static const String defaultErrorMessage = 'Unknown error';
  static const String timeoutErrorMessage = 'Operation timed out';
  static const String isolateTimeoutErrorMessage = 'Isolate communication timed out';
  static const String isolateErrorMessage = 'Isolate error';
  
  // Performance metrics
  static const double microsToMillisConversion = 1000.0;
  
  // UI Configuration
  static const Duration resultCardAnimationDuration = Duration(milliseconds: 300);
  static const double resultCardElevation = 2.0;
  static const double resultCardBorderRadius = 8.0;
}
