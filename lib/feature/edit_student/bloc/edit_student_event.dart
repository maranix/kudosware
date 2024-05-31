part of 'edit_student_bloc.dart';

sealed class EditStudentEvent extends Equatable {
  const EditStudentEvent();

  @override
  List<Object> get props => [];
}

final class EditStudentFirstNameChanged extends EditStudentEvent {
  const EditStudentFirstNameChanged(this.firstName);

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

final class EditStudentLastNameChanged extends EditStudentEvent {
  const EditStudentLastNameChanged(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

final class EditStudentGenderChanged extends EditStudentEvent {
  const EditStudentGenderChanged(this.gender);

  final String gender;

  @override
  List<Object> get props => [gender];
}

final class EditStudentDOBChanged extends EditStudentEvent {
  const EditStudentDOBChanged(this.dob);

  final DateTime dob;

  @override
  List<Object> get props => [dob];
}

final class EditStudentSubmitted extends EditStudentEvent {
  const EditStudentSubmitted();
}

final class EditStudentResetRequested extends EditStudentEvent {
  const EditStudentResetRequested();
}
