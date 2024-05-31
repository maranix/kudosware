import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/app/app.dart';
import 'package:kudosware/core/repository/authentication_repository.dart';
import 'package:kudosware/core/utils/validators.dart';
import 'package:kudosware/feature/signup/signup.dart';
import 'package:kudosware/widgets/widgets.dart';

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
        void onSuccess() {
          context.read<AppBloc>().add(AppUserChanged(state.user!));
          Navigator.of(context).pop();
        }

        return switch (state.status) {
          SignUpStatus.failure => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
              ),
            ),
          SignUpStatus.success => onSuccess(),
          _ => null,
        };
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Title(),
                  SizedBox(
                    height: min(50, MediaQuery.sizeOf(context).height * 1),
                  ),
                  const _SignUpFormView(),
                ],
              ),
            ),
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
      'Hop on\nBoard!',
      style: text.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _SignUpFormView extends StatefulWidget {
  const _SignUpFormView();

  @override
  State<_SignUpFormView> createState() => _SignUpFormViewState();
}

class _SignUpFormViewState extends State<_SignUpFormView> {
  late final GlobalKey<FormState> _formKey;

  void _onValidated() {
    if (_formKey.currentState == null) return;

    if (_formKey.currentState!.validate()) {
      context.read<SignUpBloc>().add(const SignUpRequested());
    }
  }

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(
            children: [
              Expanded(child: _FirstNameField()),
              SizedBox(width: 8),
              Expanded(child: _LastNameField()),
            ],
          ),
          const _EmailField(),
          const _PasswordField(),
          const _ConfirmPasswordField(),
          const SizedBox(height: 8),
          _SignUpActionButton(onValidated: _onValidated)
        ]
            .map((child) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: child,
                ))
            .toList(),
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
      keyboardType: TextInputType.name,
      decoration: textFieldDecoration(
        enabled: isEnabled,
        labelText: 'First Name',
        hintText: 'John',
      ),
      initialValue: firstName,
      onChanged: (name) =>
          context.read<SignUpBloc>().add(SignUpFirstNameChanged(name)),
      validator: validateFirstName,
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
      keyboardType: TextInputType.name,
      decoration: textFieldDecoration(
        enabled: isEnabled,
        labelText: 'Last Name',
        hintText: 'Doe',
      ),
      initialValue: lastName,
      onChanged: (name) =>
          context.read<SignUpBloc>().add(SignUpLastNameChanged(name)),
      validator: validateLastName,
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
      keyboardType: TextInputType.emailAddress,
      decoration: textFieldDecoration(
        enabled: isEnabled,
        labelText: 'Email',
        hintText: 'johndoe@gmail.com',
      ),
      initialValue: email,
      onChanged: (email) =>
          context.read<SignUpBloc>().add(SignUpEmailChanged(email)),
      validator: validateEmail,
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
      keyboardType: TextInputType.visiblePassword,
      decoration: textFieldDecoration(
        enabled: isEnabled,
        labelText: 'Password',
      ),
      obscureText: true,
      onChanged: (password) =>
          context.read<SignUpBloc>().add(SignUpPasswordChanged(password)),
      validator: validatePassword,
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
      keyboardType: TextInputType.visiblePassword,
      decoration: textFieldDecoration(
        enabled: isEnabled,
        labelText: 'Confirm Password',
      ),
      obscureText: true,
      onChanged: (password) => context
          .read<SignUpBloc>()
          .add(SignUpConfirmPasswordChanged(password)),
      validator: (cpass) => validateConfirmPassword(
          cpass, context.read<SignUpBloc>().state.password),
    );
  }
}

class _SignUpActionButton extends StatelessWidget {
  const _SignUpActionButton({
    required this.onValidated,
  });

  final VoidCallback onValidated;

  @override
  Widget build(BuildContext context) {
    final isEnabled = context
        .select<SignUpBloc, bool>((bloc) => bloc.state.status.isNotLoading);

    return FilledButton(
      onPressed: onValidated,
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
