import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosware/core/model/model.dart';

export './firestore_student_service.dart';

abstract interface class StudentService {
  Future<({List<StudentEntry> data, DocumentSnapshot<Object?>? lastDoc})>
      getStudents({required int limit});
  Future<StudentEntry> create(StudentEntry student);
  Future<StudentEntry> update(StudentEntry student);
  Future<void> delete(String studentId);
}
