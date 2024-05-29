import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/repository/authentication_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

final class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc({
    required AuthenticationRepository authRepo,
  })  : _repo = authRepo,
        super(const LogInState()) {
    on<LogInEmailChanged>(_onEmailChanged);
    on<LogInPasswordChanged>(_onPasswordChanged);
    on<LogInRequested>(_onRequested);
  }

  Future<void> _onEmailChanged(
    LogInEmailChanged event,
    Emitter<LogInState> emit,
  ) async {
    emit(state.copyWith(email: event.email));
  }

  Future<void> _onPasswordChanged(
    LogInPasswordChanged event,
    Emitter<LogInState> emit,
  ) async {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onRequested(
    LogInRequested event,
    Emitter<LogInState> emit,
  ) async {
    emit(state.copyWith(status: LogInStatus.loading));

    final contract = LogInContract(
      email: state.email,
      password: state.password,
    );

    final res = await _repo.login(contract);

    return switch (res) {
      ApiResponseSuccess() => emit(
          state.copyWith(
            status: LogInStatus.success,
            errorMessage: null,
          ),
        ),
      ApiResponseFailure() => emit(
          state.copyWith(
            status: LogInStatus.failure,
            errorMessage: res.message,
          ),
        ),
    };
  }

  final AuthenticationRepository _repo;
}
