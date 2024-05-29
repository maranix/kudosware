part of 'login_bloc.dart';

enum LogInStatus { inital, loading, success, failure }

final class LogInState extends Equatable {
  const LogInState({
    this.status = LogInStatus.inital,
    this.email = '',
    this.password = '',
    this.errorMessage,
  });

  final LogInStatus status;

  final String email;

  final String password;

  final String? errorMessage;

  LogInState copyWith({
    LogInStatus? status,
    String? email,
    String? password,
    String? errorMessage,
  }) {
    return LogInState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        email,
        password,
        errorMessage,
      ];
}
