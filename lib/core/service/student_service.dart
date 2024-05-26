import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosware/core/model/model.dart';

abstract interface class StudentService {
  Future<Student> create(Student student);
  Future<Student> update(Student student);
  Future<void> delete(String studentId);
}

final class FirebaseStudentService implements StudentService {
  FirebaseStudentService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const _collectionName = "students";

  // TODO: Implement Pagination
  //
  // static const _pageSize = 10;
  // Future<List<Student>> getStudents({
  //   int limit = _pageSize,
  //   Query? next,
  // }) async {}

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
