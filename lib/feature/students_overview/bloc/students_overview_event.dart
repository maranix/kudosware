part of 'students_overview_bloc.dart';

sealed class StudentsOverviewEvent extends Equatable {
  const StudentsOverviewEvent();

  @override
  List<Object> get props => [];
}

final class StudentsOverviewStudentDeleted extends StudentsOverviewEvent {
  const StudentsOverviewStudentDeleted(this.student);

  final Student student;

  @override
  List<Object> get props => [student];
}
