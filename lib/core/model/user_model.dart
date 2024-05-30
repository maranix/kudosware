import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isEmailVerified,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final bool isEmailVerified;

  static const empty = User(
    id: "",
    firstName: "",
    lastName: "",
    email: "",
    isEmailVerified: false,
  );

  factory User.fromFirebaseUser(firebase_auth.User firebaseUser) => User(
        id: firebaseUser.uid,
        firstName: firebaseUser.displayName?.split(' ')[0] ?? "",
        lastName: firebaseUser.displayName?.split(' ').skip(1).join(' ') ?? "",
        email: firebaseUser.email ?? "",
        isEmailVerified: firebaseUser.emailVerified,
      );

  String get fullName => "$firstName $lastName";

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object> get props => [
        id,
        firstName,
        lastName,
        email,
        isEmailVerified,
      ];
}
