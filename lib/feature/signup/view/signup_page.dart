import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/core/repository/authentication_repository.dart';
import 'package:kudosware/feature/signup/signup.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(
      builder: (context) {
        return const SignUpPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AuthenticationRepository>();

    return BlocProvider(
      create: (BuildContext context) => SignUpBloc(authRepo: repo),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatelessWidget {
  const _SignUpView();

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
      child: Scaffold(
        appBar: AppBar(),
        body: const SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Title(),
                _SignUpFormView(),
                Center(
                  child: _SignUpActionButton(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpFormView extends StatelessWidget {
  const _SignUpFormView();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: _FirstNameField()),
            Expanded(child: _LastNameField()),
          ],
        ),
        _EmailField(),
        _PasswordField(),
        _ConfirmPasswordField(),
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
      'Hop on\nBoard!',
      style: text.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _FirstNameField extends StatelessWidget {
  const _FirstNameField();

  @override
  Widget build(BuildContext context) {
    final isEnabled = context
        .select<SignUpBloc, bool>((bloc) => bloc.state.status.isNotLoading);
    final firstName =
        context.select<SignUpBloc, String>((bloc) => bloc.state.firstName);

    return TextFormField(
      key: const Key('signupUserView_firstName_textFormField'),
      decoration: InputDecoration(
        enabled: isEnabled,
        labelText: 'First Name',
        hintText: 'John',
      ),
      initialValue: firstName,
      onChanged: (name) =>
          context.read<SignUpBloc>().add(SignUpFirstNameChanged(name)),
    );
  }
}

class _LastNameField extends StatelessWidget {
  const _LastNameField();

  @override
  Widget build(BuildContext context) {
    final isEnabled = context
        .select<SignUpBloc, bool>((bloc) => bloc.state.status.isNotLoading);
    final lastName =
        context.select<SignUpBloc, String>((bloc) => bloc.state.lastName);

    return TextFormField(
      key: const Key('signupUserView_lastName_textFormField'),
      decoration: InputDecoration(
        enabled: isEnabled,
        labelText: 'Last Name',
        hintText: 'Doe',
      ),
      initialValue: lastName,
      onChanged: (name) =>
          context.read<SignUpBloc>().add(SignUpLastNameChanged(name)),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    final isEnabled = context
        .select<SignUpBloc, bool>((bloc) => bloc.state.status.isNotLoading);
    final email =
        context.select<SignUpBloc, String>((bloc) => bloc.state.email);

    return TextFormField(
      key: const Key('signupUserView_email_textFormField'),
      decoration: InputDecoration(
        enabled: isEnabled,
        labelText: 'Email',
        hintText: 'johndoe@gmail.com',
      ),
      initialValue: email,
      onChanged: (email) =>
          context.read<SignUpBloc>().add(SignUpEmailChanged(email)),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    final isEnabled = context
        .select<SignUpBloc, bool>((bloc) => bloc.state.status.isNotLoading);

    return TextFormField(
      key: const Key('signupUserView_password_textFormField'),
      decoration: InputDecoration(
        enabled: isEnabled,
        labelText: 'Password',
      ),
      obscureText: true,
      onChanged: (password) =>
          context.read<SignUpBloc>().add(SignUpPasswordChanged(password)),
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField();

  @override
  Widget build(BuildContext context) {
    final isEnabled = context
        .select<SignUpBloc, bool>((bloc) => bloc.state.status.isNotLoading);

    return TextFormField(
      key: const Key('signupUserView_confirmPassword_textFormField'),
      decoration: InputDecoration(
        enabled: isEnabled,
        labelText: 'Confirm Password',
      ),
      obscureText: true,
      onChanged: (password) => context
          .read<SignUpBloc>()
          .add(SignUpConfirmPasswordChanged(password)),
    );
  }
}

class _SignUpActionButton extends StatelessWidget {
  const _SignUpActionButton();

  @override
  Widget build(BuildContext context) {
    final isEnabled = context
        .select<SignUpBloc, bool>((bloc) => bloc.state.status.isNotLoading);

    return FilledButton(
      onPressed: () => context.read<SignUpBloc>().add(const SignUpRequested()),
      child: AnimatedCrossFade(
        crossFadeState:
            isEnabled ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 300),
        firstChild: const Text('Create Account'),
        secondChild: const CupertinoActivityIndicator(),
      ),
    );
  }
}
