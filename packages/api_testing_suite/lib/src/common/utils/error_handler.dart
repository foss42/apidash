import 'logger.dart';

/// A centralized error handling utility for the API testing suite.
///
/// This provides consistent error handling patterns with appropriate logging
/// and user feedback mechanisms.
class ErrorHandler {
  /// Executes a function safely and handles any exceptions that occur.
  ///
  /// [operation] - A description of the operation being performed (for logging).
  /// [action] - The function to execute.
  /// [onError] - Optional callback to handle errors in a custom way.
  /// Returns the result of [action] or null if an exception occurred.
  static T? execute<T>(
    String operation,
    T Function() action, {
    Function(Exception)? onError,
  }) {
    try {
      return action();
    } on Exception catch (e, stackTrace) {
      ApiTestLogger.error('Error during $operation', e, stackTrace);
      if (onError != null) {
        onError(e);
      }
      return null;
    }
  }

  /// Executes an async function safely and handles any exceptions that occur.
  ///
  /// [operation] - A description of the operation being performed (for logging).
  /// [action] - The async function to execute.
  /// [onError] - Optional callback to handle errors in a custom way.
  /// Returns a Future with the result of [action] or null if an exception occurred.
  static Future<T?> executeAsync<T>(
    String operation,
    Future<T> Function() action, {
    Function(Exception)? onError,
  }) async {
    try {
      return await action();
    } on Exception catch (e, stackTrace) {
      ApiTestLogger.error('Error during $operation', e, stackTrace);
      if (onError != null) {
        onError(e);
      }
      return null;
    }
  }
}
