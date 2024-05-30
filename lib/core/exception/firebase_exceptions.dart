part of 'exception.dart';

final class MalformedDocumentException extends BaseException {
  const MalformedDocumentException({
    super.message = 'Firebase document is either null or missing fields',
    this.data,
  });

  final Object? data;

  @override
  String toString() {
    return '${super.toString()}'
        '\n\n'
        'data: $data';
  }
}

/// {@template sign_up_with_email_and_password_failure}
/// Thrown during the sign up process if a failure occurs.
/// {@endtemplate}
class SignUpWithEmailAndPasswordFailure extends BaseException {
  /// {@macro sign_up_with_email_and_password_failure}
  const SignUpWithEmailAndPasswordFailure({
    super.message = 'An unknown exception occurred.',
  });

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory SignUpWithEmailAndPasswordFailure.fromFirebaseCode(
      FirebaseAuthExceptionCode code) {
    return switch (code) {
      FirebaseAuthExceptionCode.invalidEmail =>
        const SignUpWithEmailAndPasswordFailure(
          message: 'Email is not valid or badly formatted.',
        ),
      FirebaseAuthExceptionCode.userDisabled =>
        const SignUpWithEmailAndPasswordFailure(
          message:
              'This user has been disabled. Please contact support for help.',
        ),
      FirebaseAuthExceptionCode.emailAlreadyInUse =>
        const SignUpWithEmailAndPasswordFailure(
          message: 'An account already exists for that email.',
        ),
      FirebaseAuthExceptionCode.operationNotAllowed =>
        const SignUpWithEmailAndPasswordFailure(
          message: 'Operation is not allowed.  Please contact support.',
        ),
      FirebaseAuthExceptionCode.weakPassword =>
        const SignUpWithEmailAndPasswordFailure(
          message: 'Please enter a stronger password.',
        ),
      _ => const SignUpWithEmailAndPasswordFailure(
          message: 'Something went wrong, Please try again later.',
        ),
    };
  }
}

/// {@template log_in_with_email_and_password_failure}
/// Thrown during the login process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
/// {@endtemplate}
class LogInWithEmailAndPasswordFailure extends BaseException {
  /// {@macro log_in_with_email_and_password_failure}
  const LogInWithEmailAndPasswordFailure({
    super.message = 'An unknown exception occurred.',
  });

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromFirebaseCode(
      FirebaseAuthExceptionCode code) {
    return switch (code) {
      FirebaseAuthExceptionCode.invalidEmail =>
        const LogInWithEmailAndPasswordFailure(
          message: 'Email is not valid or badly formatted.',
        ),
      FirebaseAuthExceptionCode.userDisabled =>
        const LogInWithEmailAndPasswordFailure(
          message:
              'This user has been disabled. Please contact support for help.',
        ),
      FirebaseAuthExceptionCode.userNotFound =>
        const LogInWithEmailAndPasswordFailure(
          message: 'Email is not found, please create an account.',
        ),
      FirebaseAuthExceptionCode.wrongPassword =>
        const LogInWithEmailAndPasswordFailure(
          message: 'Incorrect password, please try again.',
        ),
      FirebaseAuthExceptionCode.invalidCredential =>
        const LogInWithEmailAndPasswordFailure(
          message: 'Invalid credentials, please try again.',
        ),
      _ => const LogInWithEmailAndPasswordFailure(
          message: 'Something went wrong, Please try again later.',
        ),
    };
  }
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}
