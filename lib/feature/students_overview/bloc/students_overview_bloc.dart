import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
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
    on<StudentsOverviewCollectionDocumentAdded>(_onCollectionDocumentAdded);
    on<StudentsOverviewCollectionDocumentRemoved>(_onCollectionDocumentRemoved);
    on<StudentsOverviewCollectionDocumentModified>(
        _onCollectionDocumentModified);
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
    for (final change in event.changeEvent.docChanges) {
      return switch (change.type) {
        DocumentChangeType.added =>
          add(StudentsOverviewCollectionDocumentAdded(change)),
        DocumentChangeType.removed =>
          add(StudentsOverviewCollectionDocumentRemoved(change)),
        DocumentChangeType.modified =>
          add(StudentsOverviewCollectionDocumentModified(change)),
      };
    }
  }

  Future<void> _onCollectionDocumentAdded(
    StudentsOverviewCollectionDocumentAdded event,
    Emitter<StudentsOverviewState> emit,
  ) async {
    final student = event.change.doc.data();

    if (student != null) {
      final newState = _addStudent(student);
      emit(newState);
    }
  }

  Future<void> _onCollectionDocumentRemoved(
    StudentsOverviewCollectionDocumentRemoved event,
    Emitter<StudentsOverviewState> emit,
  ) async {
    final id = event.change.doc.id;

    if (!state.studentMap.containsKey(id)) return;

    final newState = _removeStudent(id);
    emit(newState);
  }

  Future<void> _onCollectionDocumentModified(
    StudentsOverviewCollectionDocumentModified event,
    Emitter<StudentsOverviewState> emit,
  ) async {
    final doc = event.change.doc;

    if (!state.studentMap.containsKey(doc.id)) return;

    final student = doc.data();
    if (student != null) {
      final newState = _addStudent(student);
      emit(newState);
    }
  }

  Future<void> _onFetchRequested(
    StudentsOverviewFetchRequested event,
    Emitter<StudentsOverviewState> emit,
  ) async {
    if (state.studentIds.isNotEmpty) return;

    emit(state.copyWith(status: StudentsOverviewStatus.loading));

    final res = await _repo.getStudents();
    switch (res) {
      case ApiResponseSuccess():
        final newState = _addStudentList(res.data);
        emit(
          newState.copyWith(
            status: StudentsOverviewStatus.success,
            lastReceivedDocument: res.lastReceivedDocument,
          ),
        );
      case ApiResponseFailure():
        emit(
          state.copyWith(
            status: StudentsOverviewStatus.failure,
            errorMessage: res.message,
          ),
        );
    }
  }

  Future<void> _onFetchMoreRequested(
    StudentsOverviewFetchMoreRequested event,
    Emitter<StudentsOverviewState> emit,
  ) async {
    emit(state.copyWith(status: StudentsOverviewStatus.loadingMore));

    final res =
        await _repo.getStudents(lastReceived: state.lastReceivedDocument);
    switch (res) {
      case ApiResponseSuccess():
        final newState = _addStudentList(res.data);

        emit(
          newState.copyWith(
            status: StudentsOverviewStatus.success,
            lastReceivedDocument: res.lastReceivedDocument,
          ),
        );
      case ApiResponseFailure():
        emit(
          state.copyWith(
            status: StudentsOverviewStatus.failure,
            errorMessage: res.message,
          ),
        );
    }
  }

  Future<void> _onDeleteRequested(
    StudentsOverviewStudentDeletionRequested event,
    Emitter<StudentsOverviewState> emit,
  ) async {
    final res = await _repo.delete(event.studentId);

    switch (res) {
      case ApiResponseSuccess():
        final newState = _removeStudent(event.studentId);
        emit(newState);
      case ApiResponseFailure():
        emit(
          state.copyWith(
            status: StudentsOverviewStatus.failure,
            errorMessage: res.message,
          ),
        );
    }
  }

  void _collectionlistener(QuerySnapshot<StudentEntry> event) {
    add(StudentsOverviewCollectionChanged(event));
  }

  StudentsOverviewState _addStudentList(List<StudentEntry> list) {
    final ids = Set<String>.from(state.studentIds);
    final map = Map<String, StudentEntry>.from(state.studentMap);

    for (var student in list) {
      ids.add(student.id);
      map[student.id] = student;
    }

    return state.copyWith(studentIds: ids, studentMap: map);
  }

  StudentsOverviewState _addStudent(StudentEntry student) {
    final ids = <String>{student.id, ...state.studentIds};
    final map = Map<String, StudentEntry>.from(state.studentMap);

    map[student.id] = student;
    return state.copyWith(studentIds: ids, studentMap: map);
  }

  StudentsOverviewState _removeStudent(String id) {
    final ids = Set<String>.from(state.studentIds);
    final map = Map<String, StudentEntry>.from(state.studentMap);

    ids.remove(id);
    map.remove(id);

    return state.copyWith(studentIds: ids, studentMap: map);
  }

  @override
  Future<void> close() {
    _studentCollectionChangesSubscription?.cancel();
    _repo.dispose();
    return super.close();
  }

  final StudentRepository _repo;

  StreamSubscription<QuerySnapshot<StudentEntry>>?
      _studentCollectionChangesSubscription;
}
