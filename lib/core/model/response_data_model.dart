import 'package:cloud_firestore/cloud_firestore.dart';

sealed class ResponseType<T> {
  const ResponseType();
}

final class PagedData<T> extends ResponseType<T> {
  const PagedData({
    required this.data,
    this.page,
  });

  final T data;

  final int? page;
}

final class FirebasePagedData<T> extends ResponseType<T> {
  const FirebasePagedData({
    required this.data,
    this.lastDoc,
  });

  final T data;
  final DocumentSnapshot<Object?>? lastDoc;
}
