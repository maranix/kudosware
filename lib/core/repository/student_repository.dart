import 'dart:async';

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

  final _studentCollectionStreamController =
      StreamController<QuerySnapshot<Student>>.broadcast();

  Future<ApiResponse<List<Student>>> getStudents({
    int limit = _pageSize,
    DocumentSnapshot<Object?>? lastReceived,
  }) async {
    try {
      final resData = await switch (_service) {
        FirestoreStudentService() =>
          _service.getStudents(limit: limit, lastReceived: lastReceived),
        _ => throw const InvalidInterfaceImplementation(),
      };

      return ApiResponse.success(
        resData.data,
        lastReceivedDocument: resData.lastDoc,
      );
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

  Stream<QuerySnapshot<Student>> get firestoreStudentCollectionChangesStream {
    if (_service is! FirestoreStudentService) {
      throw InvalidInterfaceImplementation(
        message:
            'Requested a stream but the implementation doesn\'t expose any streams.'
            '\n\n'
            'Interface: StudentService'
            'Current Implementation: ${_service.runtimeType}'
            'Accepted Implementation: FirestoreStudentService',
      );
    }

    if (_studentCollectionStreamController.hasListener) {
      return _studentCollectionStreamController.stream;
    }

    _studentCollectionStreamController
        .addStream(_service.studentCollectionChangesStream);
    return _studentCollectionStreamController.stream;
  }

  void dispose() {
    _studentCollectionStreamController.close();
  }
}
