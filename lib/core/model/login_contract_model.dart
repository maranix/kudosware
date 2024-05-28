import 'package:equatable/equatable.dart';

class LogInContract extends Equatable {
  const LogInContract({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  static const empty = LogInContract(email: '', password: '');

  LogInContract copyWith({
    String? email,
    String? password,
  }) {
    return LogInContract(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [email, password];
}
