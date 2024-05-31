import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kudosware/core/enums.dart';
import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/repository/repository.dart';

part 'edit_student_event.dart';
part 'edit_student_state.dart';

final class EditStudentBloc extends Bloc<EditStudentEvent, EditStudentState> {
  EditStudentBloc({
    required StudentRepository repo,
    StudentEntry? student,
  })  : _repo = repo,
        _student = student,
        super(
          student == null
              ? EditStudentState()
              : EditStudentState.fromStudent(student),
        ) {
    on<EditStudentFirstNameChanged>(_onFirstNameChanged);
    on<EditStudentLastNameChanged>(_onLastNameChanged);
    on<EditStudentGenderChanged>(_onGenderChanged);
    on<EditStudentDOBChanged>(_onDOBChanged);
    on<EditStudentSubmitted>(_onSubmitted);
  }

  Future<void> _onFirstNameChanged(
    EditStudentFirstNameChanged event,
    Emitter<EditStudentState> emit,
  ) async {
    emit(
      state.copyWith(
        firstName: event.firstName,
      ),
    );
  }

  Future<void> _onLastNameChanged(
    EditStudentLastNameChanged event,
    Emitter<EditStudentState> emit,
  ) async {
    emit(
      state.copyWith(
        lastName: event.lastName,
      ),
    );
  }

  Future<void> _onGenderChanged(
    EditStudentGenderChanged event,
    Emitter<EditStudentState> emit,
  ) async {
    emit(
      state.copyWith(
        gender: event.gender,
      ),
    );
  }

  Future<void> _onDOBChanged(
    EditStudentDOBChanged event,
    Emitter<EditStudentState> emit,
  ) async {
    emit(
      state.copyWith(
        dob: event.dob,
      ),
    );
  }

  Future<void> _onSubmitted(
    EditStudentSubmitted event,
    Emitter<EditStudentState> emit,
  ) async {
    emit(state.copyWith(status: EditStudentStatus.loading));

    var student = switch (_student) {
      null => StudentEntry.empty(),
      _ => _student,
    };

    student = student.copyWith(
      firstName: state.firstName,
      lastName: state.lastName,
      gender: GenderEnum.fromString(state.gender!),
      dateOfBirth: state.dob,
      updatedAt: DateTime.now(),
    );

    ApiResponse<StudentEntry> res;
    if (_student != null) {
      res = await _repo.update(student);
    } else {
      res = await _repo.create(student);
    }

    return switch (res) {
      ApiResponseFailure() => emit(
          state.copyWith(
            status: EditStudentStatus.failure,
            errorMessage: res.message,
          ),
        ),
      ApiResponseSuccess() => emit(
          state.copyWith(
            status: EditStudentStatus.success,
            errorMessage: null,
          ),
        ),
    };
  }

  final StudentRepository _repo;

  final StudentEntry? _student;
}
