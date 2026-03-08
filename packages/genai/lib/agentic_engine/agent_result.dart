/// The type of error that caused an agent call to fail.
enum AgentErrorType {
  /// The LLM provider returned an authentication error (401/403).
  authFailure,

  /// The LLM provider returned a rate limit error (429).
  rateLimited,

  /// The LLM request or response model was invalid/null.
  invalidRequest,

  /// The LLM returned a response that failed the agent's validator
  /// after all retry attempts were exhausted.
  validationFailed,

  /// A network or HTTP error occurred while calling the LLM provider.
  networkError,

  /// An unexpected error occurred.
  unexpected,
}

/// Structured error returned when an agent call fails.
class AgentException implements Exception {
  /// The category of the error.
  final AgentErrorType type;

  /// A human-readable message describing what went wrong.
  final String message;

  /// The name of the agent that failed.
  final String agentName;

  /// How many retry attempts were made before giving up.
  final int retryAttempts;

  /// The underlying exception, if any.
  final Object? cause;

  const AgentException({
    required this.type,
    required this.message,
    required this.agentName,
    this.retryAttempts = 0,
    this.cause,
  });

  @override
  String toString() =>
      'AgentException(${type.name}): [$agentName] $message'
      '${retryAttempts > 0 ? ' (after $retryAttempts retries)' : ''}'
      '${cause != null ? '\nCaused by: $cause' : ''}';
}

/// The result of calling an AI agent — either a success with data,
/// or a failure with a structured [AgentException].
sealed class AgentResult<T> {
  const AgentResult();

  /// Returns `true` if this is a successful result.
  bool get isSuccess => this is AgentSuccess<T>;

  /// Returns `true` if this is a failure result.
  bool get isFailure => this is AgentFailure<T>;

  /// Returns the success value, or `null` if this is a failure.
  T? get valueOrNull => switch (this) {
        AgentSuccess<T>(:final value) => value,
        AgentFailure<T>() => null,
      };

  /// Returns the exception, or `null` if this is a success.
  AgentException? get exceptionOrNull => switch (this) {
        AgentSuccess<T>() => null,
        AgentFailure<T>(:final exception) => exception,
      };

  /// Maps success value using [onSuccess], or returns [onFailure] result.
  R when<R>({
    required R Function(T value) success,
    required R Function(AgentException exception) failure,
  }) =>
      switch (this) {
        AgentSuccess<T>(:final value) => success(value),
        AgentFailure<T>(:final exception) => failure(exception),
      };
}

/// A successful agent result containing the output [value].
class AgentSuccess<T> extends AgentResult<T> {
  final T value;
  const AgentSuccess(this.value);

  @override
  String toString() => 'AgentSuccess($value)';
}

/// A failed agent result containing a structured [exception].
class AgentFailure<T> extends AgentResult<T> {
  final AgentException exception;
  const AgentFailure(this.exception);

  @override
  String toString() => 'AgentFailure($exception)';
}
