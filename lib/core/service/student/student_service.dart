import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosware/core/model/model.dart';

export './firestore_student_service.dart';

abstract interface class StudentService {
  Future<({List<Student> data, DocumentSnapshot<Object?>? lastDoc})>
      getStudents({required int limit});
  Future<Student> create(Student student);
  Future<Student> update(Student student);
  Future<void> delete(String studentId);
}
