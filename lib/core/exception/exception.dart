import 'package:kudosware/core/enums.dart';

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

final class InvalidInterfaceImplementation extends BaseException {
  const InvalidInterfaceImplementation({
    super.message =
        'Received an invalid implementation of Interface, make sure the implementation is correct and belongs in the heirarchy',
  });
}
