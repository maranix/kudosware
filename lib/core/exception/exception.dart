part 'api_exceptions.dart';
part 'firebase_exceptions.dart';

sealed class BaseException implements Exception {
  const BaseException({
    required this.message,
  });

  final String message;

  @override
  String toString() {
    return "$runtimeType: $message";
  }
}
