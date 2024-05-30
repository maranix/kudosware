import 'package:equatable/equatable.dart';

class SignUpContract extends Equatable {
  const SignUpContract({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;

  static const empty = SignUpContract(
    firstName: "",
    lastName: "",
    email: "",
    password: "",
    confirmPassword: "",
  );

  String get displayName => "$firstName $lastName";

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Field cannot be empty';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null) {
      return 'Password cannot be empty';
    }

    // Minimum length requirement
    if (password.length < 8) {
      return 'Password must be at least 8 characters long.';
    }

    // Contains at least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    // Contains at least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter.';
    }

    // Contains at least one digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one digit.';
    }

    // Contains at least one special character
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  static String? validateCPassword(String password, String? cpassword) {
    if (password != cpassword) {
      return 'Passwords do not match.';
    }

    return null;
  }

  SignUpContract copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return SignUpContract(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  List<Object> get props => [
        firstName,
        lastName,
        email,
        password,
        confirmPassword,
      ];
}
