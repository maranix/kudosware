import 'package:kudosware/core/model/model.dart';

export './firestore_student_service.dart';

abstract interface class StudentService {
  Future<ResponseType> getStudents({required int limit});
  Future<Student> create(Student student);
  Future<Student> update(Student student);
  Future<void> delete(String studentId);
}
