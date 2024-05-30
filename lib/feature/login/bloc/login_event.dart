part of 'login_bloc.dart';

sealed class LogInEvent extends Equatable {
  const LogInEvent();

  @override
  List<Object> get props => [];
}

final class LogInEmailChanged extends LogInEvent {
  const LogInEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

final class LogInPasswordChanged extends LogInEvent {
  const LogInPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class LogInRequested extends LogInEvent {
  const LogInRequested();
}
