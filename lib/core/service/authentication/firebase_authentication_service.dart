import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/service/service.dart';

final class FirebaseAuthenticationService implements AuthenticationService {
  const FirebaseAuthenticationService({
    required firebase_auth.FirebaseAuth firebaseAuth,
  }) : _firebase = firebaseAuth;

  final firebase_auth.FirebaseAuth _firebase;

  @override
  Future<User> signup(SignUpContract contract) async {
    final cred = await _firebase.createUserWithEmailAndPassword(
      email: contract.email,
      password: contract.password,
    );

    await Future.wait([
      cred.user!.updateDisplayName(contract.displayName),
      cred.user!.sendEmailVerification(),
    ]);

    return User.fromFirebaseUser(cred.user!);
  }

  @override
  Future<User> login(LogInContract contract) async {
    final cred = await _firebase.signInWithEmailAndPassword(
      email: contract.email,
      password: contract.password,
    );

    return User.fromFirebaseUser(cred.user!);
  }

  @override
  Future<void> logout() async {
    await _firebase.signOut();
  }

  Stream<User> get authStateStream {
    return _firebase.authStateChanges().map(
          (user) => user == null ? User.empty : User.fromFirebaseUser(user),
        );
  }
}
