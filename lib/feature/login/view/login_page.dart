import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/core/repository/authentication_repository.dart';
import 'package:kudosware/feature/login/login.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(
      builder: (context) {
        final repo = context.read<AuthenticationRepository>();

        return BlocProvider(
          create: (BuildContext context) => LogInBloc(authRepo: repo),
          child: const LogInPage(),
        );
      },
    );
  }

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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Title(),
              _EmailField(),
              _PasswordField(),
              _LogInActionButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Text(
      'Time to Dive In',
      style: text.displaySmall,
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

    return ElevatedButton(
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
