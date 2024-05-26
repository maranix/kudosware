part of 'exception.dart';

final class MalformedDocumentException extends BaseException {
  const MalformedDocumentException({
    super.message = 'Firebase document is either null or missing fields',
    this.data,
  });

  final Object? data;

  @override
  String toString() {
    return '${super.toString()}'
        '\n\n'
        'data: $data';
  }
}
