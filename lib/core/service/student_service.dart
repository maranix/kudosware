import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosware/core/model/model.dart';

typedef FirestorePageData<T> = ({
  List<T> data,
  Query<T>? nextQuery,
});

abstract interface class StudentService {
  Future<Student> create(Student student);
  Future<Student> update(Student student);
  Future<void> delete(String studentId);
}

final class FirestoreStudentService implements StudentService {
  FirestoreStudentService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const _collectionName = "students";

  Future<FirestorePageData<Student>> getStudents({
    required int limit,
    Query<Student>? next,
  }) async {
    final query = _firestore
        .collection(_collectionName)
        .withConverter<Student>(
          fromFirestore: (snapshot, options) =>
              Student.fromFirestore(snapshot, options),
          toFirestore: (model, options) => model.toFirestore(),
        )
        .orderBy('createdAt', descending: true);

    QuerySnapshot res;
    if (next != null) {
      res = await next.limit(limit).get();
    } else {
      res = await query.limit(limit).get();
    }

    final students = res.docs.map((d) => d.data()).toList().cast<Student>();

    if (res.docs.isEmpty) {
      return (data: students, nextQuery: null);
    } else {
      final nextQuery = query.startAfterDocument(res.docs.last);
      return (data: students, nextQuery: nextQuery);
    }
  }

  @override
  Future<Student> create(Student student) async {
    final ref =
        _firestore.collection(_collectionName).doc().withConverter<Student>(
              fromFirestore: (snapshot, options) =>
                  Student.fromFirestore(snapshot, options),
              toFirestore: (model, options) => model.toFirestore(),
            );

    final data = student.copyWith(id: ref.id);
    await ref.set(data);

    return data;
  }

  @override
  Future<Student> update(Student student) async {
    final ref = _firestore.collection(_collectionName).doc(student.id);
    final data = student.toFirestore();

    await ref.update(data);

    return student;
  }

  @override
  Future<void> delete(String studentId) async {
    await _firestore.collection(_collectionName).doc(studentId).delete();
  }
}
