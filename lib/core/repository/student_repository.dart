import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosware/core/exception/exception.dart';
import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/service/service.dart';

final class StudentRepository {
  StudentRepository({
    required StudentService service,
  }) : _service = service;

  final StudentService _service;

  static const _pageSize = 10;

  Future<ApiResponse<ResponseType<List<Student>>>> getStudents({
    int limit = _pageSize,
    Query<Student>? next,
  }) async {
    try {
      final resData = await switch (_service) {
        FirestoreStudentService() =>
          _service.getStudents(limit: limit, next: next),
        _ => throw const InvalidInterfaceImplementation(),
      };

      return ApiResponse.success(resData);
    } on FirebaseException catch (e) {
      return ApiResponse.failure(
        e.message ??
            'Something went wrong while fetching Students, please try again later.',
        error: e,
        stackTrace: e.stackTrace,
      );
    } on BaseException catch (e) {
      return ApiResponse.failure(e.message);
    } catch (e) {
      return ApiResponse.failure(
        'Something went wrong while fetching Student, please try again later.',
      );
    }
  }

  Future<ApiResponse<Student>> create(Student student) async {
    try {
      final resData = await _service.create(student);
      return ApiResponse.success(resData);
    } on FirebaseException catch (e) {
      return ApiResponse.failure(
        e.message ??
            'Something went wrong while creating Student, please try again later.',
        error: e,
        stackTrace: e.stackTrace,
      );
    } on BaseException catch (e) {
      return ApiResponse.failure(e.message);
    } catch (e) {
      return ApiResponse.failure(
        'Something went wrong while creating Student, please try again later.',
      );
    }
  }

  Future<ApiResponse<Student>> update(Student student) async {
    try {
      final resData = await _service.update(student);
      return ApiResponse.success(resData);
    } on FirebaseException catch (e) {
      return ApiResponse.failure(
        e.message ??
            'Something went wrong while updating Student, please try again later.',
        error: e,
        stackTrace: e.stackTrace,
      );
    } on BaseException catch (e) {
      return ApiResponse.failure(e.message);
    } catch (e) {
      return ApiResponse.failure(
        'Something went wrong while updating Student, please try again later.',
      );
    }
  }

  Future<ApiResponse> delete(String studentId) async {
    try {
      await _service.delete(studentId);
      return ApiResponse.success(null);
    } on FirebaseException catch (e) {
      return ApiResponse.failure(
        e.message ??
            'Something went wrong while deleting Student, please try again later.',
        error: e,
        stackTrace: e.stackTrace,
      );
    } on BaseException catch (e) {
      return ApiResponse.failure(e.message);
    } catch (e) {
      return ApiResponse.failure(
        'Something went wrong while deleting Student, please try again later.',
      );
    }
  }
}
