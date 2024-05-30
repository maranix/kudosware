import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/repository/repository.dart';

part 'app_event.dart';
part 'app_state.dart';

final class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authRepo,
  })  : _authRepo = authRepo,
        super(const AppState.unauthenticated()) {
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);

    _authSubscription = _authRepo.authStateStream.listen(
      (user) => add(AppUserChanged(user)),
    );
  }

  final AuthenticationRepository _authRepo;

  late final StreamSubscription<User> _authSubscription;

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    emit(
      event.user.isNotEmpty
          ? AppState.authenticated(event.user)
          : const AppState.unauthenticated(),
    );
  }

  void _onLogoutRequested(
      AppLogoutRequested event, Emitter<AppState> emit) async {
    _authRepo.logout();
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    _authRepo.dispose();

    return super.close();
  }
}
