import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosware/core/exception/exception.dart';
import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/service/service.dart';

final class AuthenticationRepository {
  AuthenticationRepository({
    required AuthenticationService service,
  }) : _service = service;

  final AuthenticationService _service;

  final _authStateStreamController = StreamController<User>.broadcast();

  /// Signs in with the provided [SigninContract].
  Future<ApiResponse<User>> login(LogInContract contract) async {
    try {
      final user = await _service.login(contract);
      return ApiResponse.success(user);
    } on BaseException catch (e) {
      return ApiResponse.failure(e.message);
    } on FirebaseException catch (e) {
      return ApiResponse.failure(
          e.message ?? 'Something went wrong, Please try again later.');
    }
  }

  /// Creates a new user with the provided [SignupContract].
  Future<ApiResponse<User>> signup(SignUpContract contract) async {
    try {
      final user = await _service.signup(contract);
      return ApiResponse.success(user);
    } on BaseException catch (e) {
      return ApiResponse.failure(e.message);
    } on FirebaseException catch (e) {
      return ApiResponse.failure(
          e.message ?? 'Something went wrong, Please try again later.');
    }
  }

  /// Logs out the current user.
  Future<ApiResponse> logout() async {
    try {
      await _service.logout();
      return ApiResponse.success(null);
    } on BaseException catch (e) {
      return ApiResponse.failure(e.message);
    } on FirebaseException catch (e) {
      return ApiResponse.failure(
          e.message ?? 'Something went wrong, Please try again later.');
    }
  }

  Stream<User> get authStateStream {
    if (_service is! FirebaseAuthenticationService) {
      throw InvalidInterfaceImplementation(
        message:
            'Requested a stream but the implementation doesn\'t expose any streams.'
            '\n\n'
            'Interface: AuthenticationService'
            'Current Implementation: ${_service.runtimeType}'
            'Accepted Implementation: FirebaseAuthenticationService',
      );
    }

    if (_authStateStreamController.hasListener) {
      return _authStateStreamController.stream;
    }

    _authStateStreamController.addStream(_service.authStateStream);
    return _authStateStreamController.stream;
  }

  void dispose() {
    _authStateStreamController.close();
  }
}
