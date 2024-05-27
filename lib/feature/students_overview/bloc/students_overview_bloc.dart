import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:kudosware/core/exception/exception.dart';
import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/repository/repository.dart';
import 'package:kudosware/core/repository/student_repository.dart';

part 'students_overview_event.dart';
part 'students_overview_state.dart';

final class StudentsOverviewBloc
    extends Bloc<StudentsOverviewEvent, StudentsOverviewState> {
  StudentsOverviewBloc({
    required StudentRepository repo,
  })  : _repo = repo,
        super(const StudentsOverviewState()) {
    on<StudentsOverviewCollectionChanged>(_onCollectionChanged);
    on<StudentsOverviewFetchRequested>(_onFetchRequested);
    on<StudentsOverviewFetchMoreRequested>(_onFetchMoreRequested);
    on<StudentsOverviewStudentDeletionRequested>(_onDeleteRequested);

    _studentCollectionChangesSubscription = _repo
        .firestoreStudentCollectionChangesStream
        .listen(_collectionlistener);
  }

  Future<void> _onCollectionChanged(
    StudentsOverviewCollectionChanged event,
    Emitter<StudentsOverviewState> emit,
  ) async {
    // TODO: handle change events
    //
    // Add the item if we do not have it in our students list.
    // Update the item if we have it in our students list.
    // Remove the item if we have it in our students list.
    // Otherwise ignore the change event.
  }

  Future<void> _onFetchRequested(
    StudentsOverviewFetchRequested event,
    Emitter<StudentsOverviewState> emit,
  ) async {
    if (state.students.isNotEmpty) return;

    emit(state.copyWith(status: StudentsOverviewStatus.loading));
    try {
      final res = await _repo.getStudents();
      return switch (res) {
        ApiResponseSuccess() => emit(
            state.copyWith(
              status: StudentsOverviewStatus.success,
              students: res.data,
            ),
          ),
        ApiResponseFirestorePagedData() => emit(
            state.copyWith(
              status: StudentsOverviewStatus.success,
              students: res.data,
              lastReceivedDocument: res.lastReceived,
            ),
          ),
        ApiResponseFailure() => emit(
            state.copyWith(
              status: StudentsOverviewStatus.failure,
              errorMessage: res.message,
            ),
          ),
        _ => null,
      };
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          status: StudentsOverviewStatus.failure, errorMessage: e.message));
    } on BaseException catch (e) {
      emit(state.copyWith(
          status: StudentsOverviewStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
          status: StudentsOverviewStatus.failure,
          errorMessage: 'Something went wrong, please try again later'));
    }
  }

  Future<void> _onFetchMoreRequested(
    StudentsOverviewFetchMoreRequested event,
    Emitter<StudentsOverviewState> emit,
  ) async {
    emit(state.copyWith(status: StudentsOverviewStatus.loadingMore));

    try {
      final res =
          await _repo.getStudents(lastReceived: state.lastReceivedDocument);

      return switch (res) {
        ApiResponseSuccess() => emit(
            state.copyWith(
              status: StudentsOverviewStatus.success,
              students: res.data,
            ),
          ),
        ApiResponseFirestorePagedData() => emit(
            state.copyWith(
              status: StudentsOverviewStatus.success,
              students: res.data,
              lastReceivedDocument: res.lastReceived,
            ),
          ),
        ApiResponseFailure() => emit(
            state.copyWith(
              status: StudentsOverviewStatus.failure,
              errorMessage: res.message,
            ),
          ),
        _ => null,
      };
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          status: StudentsOverviewStatus.failure, errorMessage: e.message));
    } on BaseException catch (e) {
      emit(state.copyWith(
          status: StudentsOverviewStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
          status: StudentsOverviewStatus.failure,
          errorMessage: 'Something went wrong, please try again later'));
    }
  }

  Future<void> _onDeleteRequested(
    StudentsOverviewStudentDeletionRequested event,
    Emitter<StudentsOverviewState> emit,
  ) async {
    try {
      await _repo.delete(event.student.id);
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          status: StudentsOverviewStatus.failure, errorMessage: e.message));
    } on BaseException catch (e) {
      emit(state.copyWith(
          status: StudentsOverviewStatus.failure, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(
          status: StudentsOverviewStatus.failure,
          errorMessage: 'Something went wrong, please try again later'));
    }
  }

  void _collectionlistener(QuerySnapshot<Student> event) {
    add(StudentsOverviewCollectionChanged(event));
  }

  @override
  Future<void> close() {
    _studentCollectionChangesSubscription?.cancel();
    return super.close();
  }

  final StudentRepository _repo;

  StreamSubscription<QuerySnapshot<Student>>?
      _studentCollectionChangesSubscription;
}
