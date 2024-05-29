import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/core/repository/authentication_repository.dart';
import 'package:kudosware/feature/signup/signup.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(
      builder: (context) {
        final repo = context.read<AuthenticationRepository>();

        return BlocProvider(
          create: (BuildContext context) => SignUpBloc(authRepo: repo),
          child: const SignUpPage(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == SignUpStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
              ),
            );
        }
      },
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// TODO: Page Title Widget
            /// TODO: First Name Form Field
            /// TODO: Last Name Form Field
            /// TODO: Email Form Field
            /// TODO: Password Form Field
            /// TODO: Confirm Password Form Field

            /// TODO: SignUp Action Button
          ],
        ),
      ),
    );
  }
}
