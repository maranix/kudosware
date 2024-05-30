import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kudosware/app/app.dart';

class AppBarLogoutButton extends StatelessWidget {
  const AppBarLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      tooltip: 'Logout',
      onPressed: () => context.read<AppBloc>().add(const AppLogoutRequested()),
      icon: const Icon(Icons.logout),
    );
  }
}
