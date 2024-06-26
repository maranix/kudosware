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
    this.studentIds = const {},
    this.studentMap = const {},
    this.lastReceivedDocument,
    this.errorMessage,
  });

  final StudentsOverviewStatus status;

  final Set<String> studentIds;

  final Map<String, StudentEntry> studentMap;

  final DocumentSnapshot<Object?>? lastReceivedDocument;

  final String? errorMessage;

  StudentsOverviewState copyWith({
    StudentsOverviewStatus? status,
    Set<String>? studentIds,
    Map<String, StudentEntry>? studentMap,
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
