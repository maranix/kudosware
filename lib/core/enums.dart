enum GenderEnum {
  male("Male"),
  female("Female"),
  other("Other");

  factory GenderEnum.fromString(String value) {
    return GenderEnum.values.firstWhere(
      (v) => v.name == value,
    );
  }

  const GenderEnum(this.value);

  final String value;
}

enum FirebaseAuthExceptionCode {
  invalidEmail('invalid-email'),
  userNotFound('user-not-found'),
  userDisabled('user-disabled'),
  emailAlreadyInUse('email-already-in-use'),
  operationNotAllowed('operation-not-allowed'),
  weakPassword('weak-password'),
  wrongPassword('wrong-password'),
  accountExistsWithDifferentCredential(
      'account-exists-with-different-credential'),
  invalidCredential('invalid-credential'),
  invalidVerificationCode('invalid-verification-code'),
  invalidVerificationId('invalid-verification-id');

  const FirebaseAuthExceptionCode(this.code);

  final String code;

  factory FirebaseAuthExceptionCode.from(String code) {
    return FirebaseAuthExceptionCode.values.firstWhere(
      (v) => v.code == code,
    );
  }
}
