import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kudosware/core/model/model.dart';
import 'package:kudosware/core/repository/authentication_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

final class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    required AuthenticationRepository authRepo,
  })  : _repo = authRepo,
        super(const SignUpState()) {
    on<SignUpFirstNameChanged>(_onFirstNameChanged);
    on<SignUpLastNameChanged>(_onLastNameChanged);
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignUpRequested>(_onRequested);
  }

  Future<void> _onFirstNameChanged(
    SignUpFirstNameChanged event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(firstName: event.firstName));
  }

  Future<void> _onLastNameChanged(
    SignUpLastNameChanged event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(lastName: event.lastName));
  }

  Future<void> _onEmailChanged(
    SignUpEmailChanged event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(email: event.email));
  }

  Future<void> _onPasswordChanged(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _onConfirmPasswordChanged(
    SignUpConfirmPasswordChanged event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(confirmPassword: event.password));
  }

  Future<void> _onRequested(
    SignUpRequested event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(status: SignUpStatus.loading));

    final contract = SignUpContract(
      firstName: state.firstName,
      lastName: state.lastName,
      email: state.email,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );

    final res = await _repo.signup(contract);
    return switch (res) {
      ApiResponseSuccess() => emit(
          state.copyWith(
            status: SignUpStatus.success,
            user: res.data,
            errorMessage: null,
          ),
        ),
      ApiResponseFailure() => emit(
          state.copyWith(
            status: SignUpStatus.failure,
            errorMessage: res.message,
          ),
        ),
    };
  }

  final AuthenticationRepository _repo;
}
