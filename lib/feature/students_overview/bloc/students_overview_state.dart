part of 'students_overview_bloc.dart';

enum StudentsOverviewStatus {
  initial,
  loading,
  loadingMore,
  success,
  failure,
}

final class StudentsOverviewState extends Equatable {
  const StudentsOverviewState({
    this.status = StudentsOverviewStatus.initial,
    this.students = const [],
    this.lastReceivedDocument,
    this.errorMessage,
  });

  final StudentsOverviewStatus status;

  final List<Student> students;

  final DocumentSnapshot<Object?>? lastReceivedDocument;

  final String? errorMessage;

  StudentsOverviewState copyWith({
    StudentsOverviewStatus? status,
    List<Student>? students,
    DocumentSnapshot<Object?>? lastReceivedDocument,
    String? errorMessage,
  }) {
    return StudentsOverviewState(
      status: status ?? this.status,
      students: students ?? this.students,
      lastReceivedDocument: lastReceivedDocument ?? this.lastReceivedDocument,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        students,
        errorMessage,
      ];
}
