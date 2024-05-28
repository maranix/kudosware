import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/service/student/student_service.dart';

final class FirestoreStudentService implements StudentService {
  FirestoreStudentService({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  static const _collectionName = "students";

  @override
  Future<({List<Student> data, DocumentSnapshot<Object?>? lastDoc})>
      getStudents({
    required int limit,
    DocumentSnapshot<Object?>? lastReceived,
  }) async {
    final query = _firestore
        .collection(_collectionName)
        .withConverter<Student>(
          fromFirestore: (snapshot, options) =>
              Student.fromFirestore(snapshot, options),
          toFirestore: (model, options) => model.toFirestore(),
        )
        .orderBy('updated_at', descending: true)
        .limit(limit);

    QuerySnapshot<Student> res;
    if (lastReceived != null) {
      res = await query.startAfterDocument(lastReceived).get();
    } else {
      res = await query.get();
    }

    final lastDoc = res.docs.isEmpty ? null : res.docs.last;
    final students = res.docs.map((d) => d.data()).toList();
    return (data: students, lastDoc: lastDoc);
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

  Stream<QuerySnapshot<Student>> get studentCollectionChangesStream =>
      _firestore
          .collection(_collectionName)
          .withConverter<Student>(
            fromFirestore: (snapshot, options) =>
                Student.fromFirestore(snapshot, options),
            toFirestore: (model, options) => model.toFirestore(),
          )
          .orderBy('updated_at', descending: true)
          .snapshots();
}
