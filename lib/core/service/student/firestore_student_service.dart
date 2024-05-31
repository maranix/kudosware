import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/service/student/student_service.dart';

final class FirestoreStudentService implements StudentService {
  FirestoreStudentService({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  final FirebaseFirestore _firestore;

  static const _collectionName = "students";
  String get _currentUserId {
    return _firebaseAuth.currentUser!.uid;
  }

  CollectionReference<StudentEntry> get _queryCollection =>
      _firestore.collection(_collectionName).withConverter<StudentEntry>(
            fromFirestore: (snapshot, options) =>
                StudentEntry.fromFirestore(snapshot, options),
            toFirestore: (model, options) => model.toFirestore(),
          );

  Query<StudentEntry> get _queryUserEntries => _queryCollection.where(
        'user_id',
        isEqualTo: _currentUserId,
      );

  @override
  Future<({List<StudentEntry> data, DocumentSnapshot<Object?>? lastDoc})>
      getStudents({
    required int limit,
    DocumentSnapshot<Object?>? lastReceived,
  }) async {
    final query =
        _queryUserEntries.orderBy('updated_at', descending: true).limit(limit);

    QuerySnapshot<StudentEntry> res;
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
  Future<StudentEntry> create(StudentEntry student) async {
    final ref = _queryCollection.doc();
    final data = student.copyWith(id: ref.id, userId: _currentUserId);

    await ref.set(data);
    return data;
  }

  @override
  Future<StudentEntry> update(StudentEntry student) async {
    final ref = _queryCollection.doc(student.id);
    final data = student.toFirestore();

    await ref.update(data);
    return student;
  }

  @override
  Future<void> delete(String studentId) async {
    await _queryCollection.doc(studentId).delete();
  }

  Stream<QuerySnapshot<StudentEntry>> get studentCollectionChangesStream =>
      _queryUserEntries.orderBy('updated_at', descending: true).snapshots();
}
