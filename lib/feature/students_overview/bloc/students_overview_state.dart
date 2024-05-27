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
    this.studentIds = const [],
    this.studentMap = const {},
    this.lastReceivedDocument,
    this.errorMessage,
  });

  final StudentsOverviewStatus status;

  final List<String> studentIds;

  final Map<String, Student> studentMap;

  final DocumentSnapshot<Object?>? lastReceivedDocument;

  final String? errorMessage;

  StudentsOverviewState copyWith({
    StudentsOverviewStatus? status,
    List<String>? studentIds,
    Map<String, Student>? studentMap,
    DocumentSnapshot<Object?>? lastReceivedDocument,
    String? errorMessage,
  }) {
    return StudentsOverviewState(
      status: status ?? this.status,
      studentIds: studentIds ?? this.studentIds,
      studentMap: studentMap ?? this.studentMap,
      lastReceivedDocument: lastReceivedDocument ?? this.lastReceivedDocument,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        studentIds,
        studentMap,
        lastReceivedDocument,
        errorMessage,
      ];
}
