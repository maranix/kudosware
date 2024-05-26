import 'package:kudosware/core/model/model.dart';

export './firestore_student_service.dart';

abstract interface class StudentService {
  Future<Student> create(Student student);
  Future<Student> update(Student student);
  Future<void> delete(String studentId);
}
