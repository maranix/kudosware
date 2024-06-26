import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/app/app.dart';
import 'package:kudosware/core/repository/repository.dart';
import 'package:kudosware/feature/home/home.dart';
import 'package:kudosware/feature/login/login.dart';

class KudoswareApp extends StatelessWidget {
  const KudoswareApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = context.read<AuthenticationRepository>();

    return BlocProvider(
      create: (context) => AppBloc(
        authRepo: authRepo,
      ),
      child: const _KudoswareView(),
    );
  }
}

class _KudoswareView extends StatelessWidget {
  const _KudoswareView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const Color(0xFFd6eadf),
        ),
      ),
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xff809bce),
        ),
      ),
      home: const _AuthGuard(),
    );
  }
}

class _AuthGuard extends StatelessWidget {
  const _AuthGuard();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppBloc, AppState, AppStatus>(
      selector: (state) => state.status,
      builder: (context, status) {
        return switch (status) {
          AppStatus.authenticated => const HomePage(),
          AppStatus.unauthenticated => const LogInPage(),
        };
      },
    );
  }
}
