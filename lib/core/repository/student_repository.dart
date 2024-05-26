import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/service/service.dart';

final class StudentRepository {
  StudentRepository({
    required StudentService studentService,
  }) : _service = studentService;

  final StudentService _service;

  Future<Student> create(Student student) async {
    final resData = await _service.create(student);
    return resData;
  }

  Future<Student> update(Student student) async {
    final resData = await _service.update(student);
    return resData;
  }

  Future<void> delete(String studentId) async {
    await _service.delete(studentId);
  }
}
