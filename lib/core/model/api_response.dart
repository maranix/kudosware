sealed class ApiResponse<T> {
  const ApiResponse();

  factory ApiResponse.success(T data) => ApiResponseSuccess(data);
  factory ApiResponse.failure(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) =>
      ApiResponseFailure(
        message,
        error: error,
        stackTrace: stackTrace,
      );
}

final class ApiResponseSuccess<T> extends ApiResponse<T> {
  const ApiResponseSuccess(this.data);

  final T data;
}

final class ApiResponseFailure<T> extends ApiResponse<T> {
  const ApiResponseFailure(
    this.message, {
    this.error,
    this.stackTrace,
  });

  final String message;
  final Object? error;
  final StackTrace? stackTrace;
}
