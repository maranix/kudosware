import 'package:cloud_firestore/cloud_firestore.dart';

sealed class ApiResponse<T> {
  const ApiResponse();

  factory ApiResponse.success(
    T data, {
    DocumentSnapshot<Object?>? lastReceivedDocument,
  }) =>
      ApiResponseSuccess(data, lastReceivedDocument: lastReceivedDocument);

  factory ApiResponse.failure(String message,
          {Object? error, StackTrace? stackTrace}) =>
      ApiResponseFailure(
        message,
        error: error,
        stackTrace: stackTrace,
      );
}

final class ApiResponseSuccess<T> extends ApiResponse<T> {
  const ApiResponseSuccess(
    this.data, {
    this.lastReceivedDocument,
  });

  final T data;

  final DocumentSnapshot<Object?>? lastReceivedDocument;
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
