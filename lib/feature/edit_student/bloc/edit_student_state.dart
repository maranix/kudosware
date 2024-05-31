part of 'edit_student_bloc.dart';

enum EditStudentStatus {
  initial,
  loading,
  success,
  failure,
}

final class EditStudentState extends Equatable {
  factory EditStudentState() {
    return const EditStudentState._(
      status: EditStudentStatus.initial,
      firstName: '',
      lastName: '',
      isEditing: false,
    );
  }

  factory EditStudentState.fromStudent(StudentEntry student) {
    return EditStudentState._(
      status: EditStudentStatus.initial,
      firstName: student.firstName,
      lastName: student.lastName,
      gender: student.gender.name,
      dob: student.dateOfBirth,
      isEditing: true,
    );
  }

  const EditStudentState._({
    required this.status,
    required this.firstName,
    required this.lastName,
    required this.isEditing,
    this.gender,
    this.dob,
    this.errorMessage,
  });

  final EditStudentStatus status;

  final String firstName;

  final String lastName;

  final String? gender;

  final DateTime? dob;

  final bool isEditing;

  final String? errorMessage;

  EditStudentState copyWith({
    EditStudentStatus? status,
    String? firstName,
    String? lastName,
    String? gender,
    DateTime? dob,
    bool? isEditing,
    String? errorMessage,
  }) {
    return EditStudentState._(
      status: status ?? EditStudentStatus.initial,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      isEditing: isEditing ?? this.isEditing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        firstName,
        lastName,
        gender,
        dob,
        isEditing,
        errorMessage,
      ];
}
