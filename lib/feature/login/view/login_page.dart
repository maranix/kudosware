import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/core/repository/authentication_repository.dart';
import 'package:kudosware/feature/login/login.dart';
import 'package:kudosware/feature/signup/signup.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AuthenticationRepository>();

    return BlocProvider(
      create: (BuildContext context) => LogInBloc(authRepo: repo),
      child: const _LogInView(),
    );
  }
}

class _LogInView extends StatelessWidget {
  const _LogInView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogInBloc, LogInState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == LogInStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
              ),
            );
        }
      },
      child: const Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title(),
                  _LogInFormView(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _SignUpActionButton(),
                  ),
                  Center(
                    child: _LogInActionButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogInFormView extends StatelessWidget {
  const _LogInFormView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _EmailField(),
        _PasswordField(),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Text(
      'Time to\nDive In',
      style: text.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    final isEnabled = context
        .select<LogInBloc, bool>((bloc) => bloc.state.status.isNotLoading);
    final email = context.select<LogInBloc, String>((bloc) => bloc.state.email);

    return TextFormField(
      key: const Key('loginUserView_email_textFormField'),
      decoration: InputDecoration(
        enabled: isEnabled,
        labelText: 'Email',
        hintText: 'johndoe@gmail.com',
      ),
      initialValue: email,
      onChanged: (email) =>
          context.read<LogInBloc>().add(LogInEmailChanged(email)),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    final isEnabled = context
        .select<LogInBloc, bool>((bloc) => bloc.state.status.isNotLoading);

    return TextFormField(
      key: const Key('loginUserView_password_textFormField'),
      decoration: InputDecoration(
        enabled: isEnabled,
        labelText: 'Password',
      ),
      onChanged: (password) =>
          context.read<LogInBloc>().add(LogInPasswordChanged(password)),
    );
  }
}

class _LogInActionButton extends StatelessWidget {
  const _LogInActionButton();

  @override
  Widget build(BuildContext context) {
    final isEnabled = context
        .select<LogInBloc, bool>((bloc) => bloc.state.status.isNotLoading);

    return FilledButton(
      onPressed: () => context.read<LogInBloc>().add(const LogInRequested()),
      child: AnimatedCrossFade(
        crossFadeState:
            isEnabled ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 300),
        firstChild: const Text('Login'),
        secondChild: const CupertinoActivityIndicator(),
      ),
    );
  }
}

class _SignUpActionButton extends StatelessWidget {
  const _SignUpActionButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).push(SignUpPage.route()),
      child: const Text('Don\'t have an account?'),
    );
  }
}
