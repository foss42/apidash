import 'dart:io';
import 'dart:async';
import 'dart:developer' show log;

/// A lightweight HTTP server for handling OAuth callbacks on desktop platforms.
/// This provides a standard localhost callback URL that's compatible with most OAuth providers.
class OAuthCallbackServer {
  HttpServer? _server;
  late int _port;
  String? _path;
  final Completer<String> _completer = Completer<String>();
  Timer? _timeoutTimer;
  bool _isCancelled = false;

  /// Starts the HTTP server and returns the callback URL.
  ///
  /// [path] - Optional path for the callback endpoint (defaults to '/callback')
  /// Returns the full callback URL (e.g., 'http://localhost:8080/callback')
  Future<String> start({String path = '/callback'}) async {
    _path = path;

    // Try to bind to a random available port starting from 8080
    for (int port = 8080; port <= 8090; port++) {
      try {
        _server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
        _port = port;
        break;
      } catch (e) {
        // Port is busy, try next one
        if (port == 8090) {
          throw Exception(
            'Unable to find available port for OAuth callback server',
          );
        }
      }
    }

    if (_server == null) {
      throw Exception('Failed to start OAuth callback server');
    }

    _server!.listen(_handleRequest);

    final callbackUrl = 'http://localhost:$_port$_path';
    log('OAuth callback server started at: $callbackUrl');

    return callbackUrl;
  }

  /// Waits for the OAuth callback and returns the full callback URL with query parameters.
  ///
  /// [timeout] - Optional timeout duration (defaults to 3 minutes)
  /// Throws [TimeoutException] if no callback is received within the timeout period.
  /// Throws [Exception] if the OAuth flow was manually cancelled.
  Future<String> waitForCallback({
    Duration timeout = const Duration(minutes: 3),
  }) async {
    // Check if already cancelled before starting
    if (_isCancelled) {
      throw Exception('OAuth flow was cancelled');
    }

    // Set up timeout timer
    _timeoutTimer = Timer(timeout, () {
      if (!_completer.isCompleted && !_isCancelled) {
        _completer.completeError(
          TimeoutException(
            'OAuth callback timeout: No response received within ${timeout.inMinutes} minutes. '
            'You can manually cancel this operation or wait for completion.',
            timeout,
          ),
        );

        // Automatically stop the server on timeout
        _stopServerOnError(
          'OAuth flow timed out after ${timeout.inMinutes} minutes',
        );
      }
    });

    try {
      return await _completer.future;
    } finally {
      _timeoutTimer?.cancel();
      _timeoutTimer = null;
    }
  }

  /// Stops the HTTP server and cleans up resources.
  Future<void> stop() async {
    if (_server == null) {
      log('OAuth callback server already stopped');
      return;
    }

    _timeoutTimer?.cancel();
    _timeoutTimer = null;

    try {
      await _server?.close();
      log('OAuth callback server stopped gracefully');
    } catch (e) {
      log('Error during graceful server stop: $e');
    } finally {
      _server = null;
    }
  }

  /// Cancels the waiting callback operation.
  /// This is useful when the user wants to cancel the OAuth flow manually.
  void cancel([String reason = 'OAuth flow cancelled by user']) {
    _isCancelled = true;
    _timeoutTimer?.cancel();
    _timeoutTimer = null;

    if (!_completer.isCompleted) {
      _completer.completeError(Exception('OAuth callback cancelled: $reason'));
    }

    // Automatically stop the server when cancelled
    _stopServerOnError(reason);
  }

  /// Checks if the OAuth flow was cancelled
  bool get isCancelled => _isCancelled;

  /// Stops the server immediately due to an error condition
  /// This is used for automatic cleanup when errors occur
  void _stopServerOnError(String reason) {
    if (_server == null) {
      log('OAuth callback server already stopped, skipping error stop');
      return;
    }

    log('Stopping OAuth callback server due to error: $reason');

    // Cancel any active timers
    _timeoutTimer?.cancel();
    _timeoutTimer = null;

    // Close the server without waiting
    _server
        ?.close(force: true)
        .then((_) {
          log('OAuth callback server forcefully stopped due to error');
        })
        .catchError((error) {
          log('Error while force-stopping server: $error');
        });

    _server = null;
  }

  void _handleRequest(HttpRequest request) {
    log('OAuth request received: ${request.uri}');

    try {
      // Handle OPTIONS preflight requests for CORS
      if (request.method == 'OPTIONS') {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
          ..headers.add('Access-Control-Allow-Headers', 'Content-Type')
          ..close();
        return;
      }

      // Check if this is an authorization callback (has 'code' or 'error' parameters)
      final uri = request.uri;
      final hasCode = uri.queryParameters.containsKey('code');
      final hasError = uri.queryParameters.containsKey('error');

      String responseHtml;

      if (hasError) {
        final error = uri.queryParameters['error'] ?? 'unknown_error';
        final errorDescription =
            uri.queryParameters['error_description'] ??
            'No description provided';
        responseHtml = _generateErrorHtml(error, errorDescription);

        // Complete the future with error and stop server
        if (!_completer.isCompleted) {
          _completer.completeError(
            Exception('OAuth authorization failed: $error - $errorDescription'),
          );
        }

        // Send response to browser first, then stop server after a delay
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.html
          ..write(responseHtml)
          ..close();

        // Stop server after sending response (with a small delay)
        Timer(const Duration(seconds: 1), () {
          _stopServerOnError('OAuth authorization error: $error');
        });

        return;
      } else if (hasCode) {
        responseHtml = _generateSuccessHtml();
      } else {
        responseHtml = _generateInfoHtml();
      }

      // Send response to the browser
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.html
        ..write(responseHtml)
        ..close();

      // Complete the future with the full callback URL
      if (!_completer.isCompleted) {
        _completer.complete(request.uri.toString());
      }

      // For successful authorization, schedule server stop after response
      if (hasCode) {
        Timer(const Duration(seconds: 6), () {
          _stopServerOnError('OAuth flow completed successfully');
        });
      }
    } catch (e) {
      log('Error handling OAuth callback request: $e');

      // Complete with error if not already completed
      if (!_completer.isCompleted) {
        _completer.completeError(
          Exception('OAuth callback request handling failed: $e'),
        );
      }

      // Try to send an error response
      try {
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..write('Internal server error occurred during OAuth callback')
          ..close();
      } catch (responseError) {
        log('Failed to send error response: $responseError');
      }

      // Stop server due to error
      _stopServerOnError('Request handling error: $e');
    }
  }

  String _generateSuccessHtml() {
    return '''
<!DOCTYPE html>
<html>
<head>
  <title>OAuth Authentication Successful</title>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; padding: 50px; background: #f8f9fa; }
    .container { max-width: 500px; margin: 0 auto; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    .success { color: #28a745; font-size: 48px; margin-bottom: 20px; }
    .title { color: #333; font-size: 24px; margin-bottom: 15px; }
    .message { color: #6c757d; font-size: 16px; line-height: 1.5; }
    .countdown { color: #007bff; font-weight: bold; margin-top: 20px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="success">✓</div>
    <div class="title">Authentication Successful!</div>
    <div class="message">
      Your OAuth authorization was completed successfully. 
      You can now close this window and return to API Dash.
    </div>
    <div class="countdown" id="countdown">This window will close automatically in <span id="timer">5</span> seconds...</div>
  </div>
  <script>
    let seconds = 5;
    const timer = document.getElementById('timer');
    
    // Countdown timer
    const countdown = setInterval(() => {
      seconds--;
      timer.textContent = seconds;
      if (seconds <= 0) {
        clearInterval(countdown);
        window.close();
      }
    }, 1000);
  </script>
</body>
</html>
    ''';
  }

  String _generateErrorHtml(String error, String errorDescription) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <title>OAuth Authentication Failed</title>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; padding: 50px; background: #f8f9fa; }
    .container { max-width: 500px; margin: 0 auto; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    .error { color: #dc3545; font-size: 48px; margin-bottom: 20px; }
    .title { color: #333; font-size: 24px; margin-bottom: 15px; }
    .message { color: #6c757d; font-size: 16px; line-height: 1.5; margin-bottom: 20px; }
    .details { background: #f8f9fa; padding: 15px; border-radius: 4px; font-family: monospace; font-size: 14px; color: #495057; margin: 15px 0; }
    .countdown { color: #007bff; font-weight: bold; margin-top: 20px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="error">✗</div>
    <div class="title">Authentication Failed</div>
    <div class="message">
      The OAuth authorization was not completed successfully. 
      Please try again from API Dash.
    </div>
    <div class="details">
      <strong>Error:</strong> $error<br>
      <strong>Description:</strong> $errorDescription
    </div>
    <div class="countdown" id="countdown">This window will close automatically in <span id="timer">10</span> seconds...</div>
  </div>
  <script>
    let seconds = 10;
    const timer = document.getElementById('timer');
    
    // Countdown timer
    const countdown = setInterval(() => {
      seconds--;
      timer.textContent = seconds;
      if (seconds <= 0) {
        clearInterval(countdown);
        window.close();
      }
    }, 1000);
  </script>
</body>
</html>
    ''';
  }

  String _generateInfoHtml() {
    return '''
<!DOCTYPE html>
<html>
<head>
  <title>OAuth Callback Server</title>
  <style>
    body { font-family: Arial, sans-serif; text-align: center; padding: 50px; background: #f8f9fa; }
    .container { max-width: 500px; margin: 0 auto; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    .info { color: #17a2b8; font-size: 48px; margin-bottom: 20px; }
    .title { color: #333; font-size: 24px; margin-bottom: 15px; }
    .message { color: #6c757d; font-size: 16px; line-height: 1.5; }
  </style>
</head>
<body>
  <div class="container">
    <div class="info">ℹ</div>
    <div class="title">OAuth Callback Server</div>
    <div class="message">
      This is the OAuth callback endpoint for API Dash. 
      If you're seeing this page, the callback server is running correctly.
      Please return to API Dash to complete the OAuth flow.
    </div>
  </div>
</body>
</html>
    ''';
  }
}
