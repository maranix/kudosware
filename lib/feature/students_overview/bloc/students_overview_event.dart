part of 'students_overview_bloc.dart';

sealed class StudentsOverviewEvent extends Equatable {
  const StudentsOverviewEvent();

  @override
  List<Object> get props => [];
}

final class StudentsOverviewCollectionChanged extends StudentsOverviewEvent {
  const StudentsOverviewCollectionChanged(this.changeEvent);

  final QuerySnapshot<StudentEntry> changeEvent;

  @override
  List<Object> get props => [changeEvent];
}

final class StudentsOverviewCollectionDocumentAdded
    extends StudentsOverviewEvent {
  const StudentsOverviewCollectionDocumentAdded(this.change);

  final DocumentChange<StudentEntry> change;

  @override
  List<Object> get props => [change];
}

final class StudentsOverviewCollectionDocumentRemoved
    extends StudentsOverviewEvent {
  const StudentsOverviewCollectionDocumentRemoved(this.change);

  final DocumentChange<StudentEntry> change;

  @override
  List<Object> get props => [change];
}

final class StudentsOverviewCollectionDocumentModified
    extends StudentsOverviewEvent {
  const StudentsOverviewCollectionDocumentModified(this.change);

  final DocumentChange<StudentEntry> change;

  @override
  List<Object> get props => [change];
}

final class StudentsOverviewFetchRequested extends StudentsOverviewEvent {
  const StudentsOverviewFetchRequested();
}

final class StudentsOverviewFetchMoreRequested extends StudentsOverviewEvent {
  const StudentsOverviewFetchMoreRequested();
}

final class StudentsOverviewStudentDeletionRequested
    extends StudentsOverviewEvent {
  const StudentsOverviewStudentDeletionRequested(this.studentId);

  final String studentId;

  @override
  List<Object> get props => [studentId];
}
