import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosware/core/exception/exception.dart';
import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/service/service.dart';

final class StudentRepository {
  StudentRepository({
    required StudentService studentService,
  }) : _service = studentService;

  final StudentService _service;

  static const _pageSize = 10;

  // Important: Not a priority at the moment
  //
  // TODO: Refactor this more to make it more modular and re-usable
  //
  // Ideally [StudentRepository] should be able to work with any implementation of [StudentService].
  // Here we are concretely specifying that it'll return a [FirestorePageData] in case of Success.
  // This limits the reusability of this repository as [get] method will essentially only work for
  // FirestoreStudentService instances.
  //
  Future<ApiResponse<FirestorePageData>> get({
    int limit = _pageSize,
    Query<Student>? next,
  }) async {
    try {
      final resData = await (_service as FirestoreStudentService).getStudents(
        limit: limit,
        next: next,
      );
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
