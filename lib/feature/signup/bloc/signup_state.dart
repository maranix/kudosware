part of 'signup_bloc.dart';

enum SignUpStatus { inital, loading, success, failure }

extension SignUpStatusX on SignUpStatus {
  bool get isLoading => this == SignUpStatus.loading;

  bool get isNotLoading => this != SignUpStatus.loading;
}

final class SignUpState extends Equatable {
  const SignUpState({
    this.status = SignUpStatus.inital,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.errorMessage,
  });

  final SignUpStatus status;

  final String firstName;

  final String lastName;

  final String email;

  final String password;

  final String confirmPassword;

  final String? errorMessage;

  SignUpState copyWith({
    SignUpStatus? status,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmPassword,
    String? errorMessage,
  }) {
    return SignUpState(
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        firstName,
        lastName,
        email,
        password,
        confirmPassword,
        errorMessage,
      ];
}
