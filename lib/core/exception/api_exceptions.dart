part of 'exception.dart';

final class ApiException extends BaseException {
  const ApiException({
    super.message = 'An unknown error occured.',
  });
}
