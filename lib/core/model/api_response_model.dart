import 'package:cloud_firestore/cloud_firestore.dart';

sealed class ApiResponse<T> {
  const ApiResponse();

  factory ApiResponse.success(T data) => ApiResponseSuccess(data);
  factory ApiResponse.pagedData(T data, int? page) =>
      ApiResponsePagedData(data, page: page);
  factory ApiResponse.firstorePagedData(
          T data, DocumentSnapshot<Object?>? lastReceived) =>
      ApiResponseFirestorePagedData(data, lastReceived: lastReceived);
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

final class ApiResponsePagedData<T> extends ApiResponse<T> {
  const ApiResponsePagedData(
    this.data, {
    this.page,
  });

  final T data;

  final int? page;
}

final class ApiResponseFirestorePagedData<T> extends ApiResponse<T> {
  const ApiResponseFirestorePagedData(
    this.data, {
    this.lastReceived,
  });

  final T data;

  final DocumentSnapshot<Object?>? lastReceived;
}
